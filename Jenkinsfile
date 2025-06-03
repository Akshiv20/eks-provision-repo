pipeline {
    agent any

    environment {
        VAULT_ADDR = 'http://127.0.0.1:8200'
        // Uncomment and update this if you want to fetch AWS creds from Vault
        // VAULT_SECRET_PATH = 'aws/creds/eks-role' 
        TERRAFORM_DIR = 'terraform'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Akshiv20/eks-provision-repo.git'
                    ]]
                ])
            }
        }

        stage('🔐 Get AWS Credentials from Vault') {
            steps {
                script {
                    // Fetch AWS credentials from Vault and set env variables
                    def creds = sh(
                        script: "vault read -format=json ${VAULT_SECRET_PATH}",
                        returnStdout: true
                    ).trim()

                    def json = readJSON text: creds

                    env.AWS_ACCESS_KEY_ID     = json.data.access_key
                    env.AWS_SECRET_ACCESS_KEY = json.data.secret_key
                    env.AWS_SESSION_TOKEN     = json.data.security_token

                    echo "AWS credentials fetched from Vault successfully."
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
                    sh 'checkov -d . > checkov_report.txt || true'
                    archiveArtifacts artifacts: 'checkov_report.txt', fingerprint: true
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
