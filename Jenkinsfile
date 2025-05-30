pipeline {
    agent any

    environment {
        VAULT_ADDR = 'http://127.0.0.1:8200'  // Change if needed
    }

    stages {
        stage('Read AWS Credentials from Vault') {
            steps {
                script {
                    withVault(
                        configuration: [
                            vaultUrl: "${VAULT_ADDR}",
                            vaultCredentialId: 'vault-token'
                        ],
                        vaultSecrets: [
                            [
                                path: 'awscreds/awscreds',
                                engineVersion: 2,
                                secretValues: [
                                    [envVar: 'AWS_ACCESS_KEY_ID', vaultKey: 'AWS_ACCESS_KEY_ID'],
                                    [envVar: 'AWS_SECRET_ACCESS_KEY', vaultKey: 'AWS_SECRET_ACCESS_KEY']
                                ]
                            ]
                        ]
                    ) {
                        echo "AWS credentials retrieved successfully from Vault."
                        // Optional: Print the first few chars for debug (never print full keys)
                        echo "Access Key ID starts with: ${AWS_ACCESS_KEY_ID.take(4)}***"
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input(message: 'Do you want to apply the changes?')
                sh 'terraform apply -auto-approve'
            }
        }
    }
}

