pipeline {
    agent any

    environment {
        VAULT_ADDR = 'http://127.0.0.1:8200'
    }

    stages {
        stage('Read AWS Credentials from Vault') {
            steps {
                script {
                    withVault(
                        configuration: [
                            vaultUrl: "${env.VAULT_ADDR}",
                            vaultCredentialId: 'vault-token' // This must match Jenkins -> Credentials ID
                        ],
                        vaultSecrets: [
                            [
                                path: 'awscreds/awscreds',
                                secretValues: [
                                    [envVar: 'AWS_ACCESS_KEY_ID', vaultKey: 'AWS_ACCESS_KEY_ID'],
                                    [envVar: 'AWS_SECRET_ACCESS_KEY', vaultKey: 'AWS_SECRET_ACCESS_KEY']
                                ]
                            ]
                        ]
                    ) {
                        echo "Vault credentials successfully loaded."
                        sh 'echo $AWS_ACCESS_KEY_ID'
                        sh 'echo $AWS_SECRET_ACCESS_KEY'
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
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
