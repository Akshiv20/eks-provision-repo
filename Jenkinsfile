pipeline {
    agent any

    environment {
        VAULT_ADDR = 'http://127.0.0.1:8200'
    }

    stages {
        stage('Terraform Pipeline with Vault') {
            steps {
                script {
                    withVault(
                        configuration: [
                            vaultUrl: "${env.VAULT_ADDR}",
                            vaultCredentialId: 'vault-token' // Must match Jenkins Credentials ID
                        ],
                        vaultSecrets: [
                            [
                                path: 'awscreds',
                                secretValues: [
                                    [envVar: 'AWS_ACCESS_KEY_ID', vaultKey: 'AWS_ACCESS_KEY_ID'],
                                    [envVar: 'AWS_SECRET_ACCESS_KEY', vaultKey: 'AWS_SECRET_ACCESS_KEY']
                                ]
                            ]
                        ]
                    ) {
                        echo "Vault credentials successfully loaded."

                        // Optional: Verify environment variables
                        sh 'echo $AWS_ACCESS_KEY_ID'
                        sh 'echo $AWS_SECRET_ACCESS_KEY'

                        // Run Terraform commands within the same environment
                        sh 'terraform init'
                        sh 'terraform plan'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}
