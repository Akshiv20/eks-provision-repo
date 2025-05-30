pipeline {
    agent any

    environment {
        VAULT_ADDR = 'http://127.0.0.1:8200'
        VAULT_SECRET_PATH = 'aws/creds/eks-role'
        TERRAFORM_DIR = 'terraform'
    }

    stages {
        stage('🔐 Get AWS Credentials from Vault') {
            steps {
                script {
                    def creds = sh(
                        script: "vault read -format=json ${VAULT_SECRET_PATH}",
                        returnStdout: true
                    ).trim()
                    
                    def json = readJSON text: creds
                    env.AWS_ACCESS_KEY_ID     = json.data.access_key
                    env.AWS_SECRET_ACCESS_KEY = json.data.secret_key
                    env.AWS_SESSION_TOKEN     = json.data.security_token
                }
            }
        }

        stage('🚀 Terraform Init') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('🔎 Checkov Scan') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh '''
                    docker run --rm -t \
                      -v $(pwd):/tf \
                      -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
                      -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
                      -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
                      bridgecrew/checkov -d /tf
                    '''
                }
            }
        }

        stage('📝 Terraform Plan') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform plan'
                }
            }
        }

        stage('✅ Terraform Apply') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    input message: 'Do you want to apply the Terraform changes?'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
