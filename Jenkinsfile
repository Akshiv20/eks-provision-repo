pipeline {
    agent any

    // Vault secret path: Adjust as per your setup or remove Vault usage if not fetching creds
    // VAULT_SECRET_PATH = 'aws/creds/eks-role' 

    environment {
        VAULT_ADDR = 'http://127.0.0.1:8200'
        TERRAFORM_DIR = 'terraform'
    }

    stages {
        stage('🔐 Get AWS Credentials from Vault (Optional)') {
            steps {
                script {
                    // If you're NOT using Vault to fetch creds, comment out or remove this block
                    // If IAM Role attached to Jenkins agent is sufficient, you can skip this stage
                    // Here is example if you want to use Vault:

                    /*
                    def creds = sh(
                        script: "vault read -format=json ${VAULT_SECRET_PATH}",
                        returnStdout: true
                    ).trim()

                    def json = readJSON text: creds
                    env.AWS_ACCESS_KEY_ID     = json.data.access_key
                    env.AWS_SECRET_ACCESS_KEY = json.data.secret_key
                    env.AWS_SESSION_TOKEN     = json.data.security_token
                    */
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
                    // Run Checkov directly (pip installed)
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
