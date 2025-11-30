pipeline {
    agent any

    environment {
        DEV_IMAGE = "maruvarasivasu/dev:latest"
        PROD_IMAGE = "maruvarasivasu/prod:latest"
        APP_PORT = "80"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/MaruvarasiVasu/devops-build.git'
            }
        }

        stage('Set Branch') {
            steps {
                script {
                    env.CURRENT_BRANCH = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                    echo "Current branch: ${env.CURRENT_BRANCH}"
                }
            }
        }

        stage('Install & Build React App') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.CURRENT_BRANCH == 'dev') {
                        sh "docker build -t ${DEV_IMAGE} ."
                    } else if (env.CURRENT_BRANCH == 'main') {
                        sh "docker build -t ${PROD_IMAGE} ."
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    if (env.CURRENT_BRANCH == 'dev') {
                        sh "docker login -u maruvarasivasu -p yourdockerhubpassword"
                        sh "docker push ${DEV_IMAGE}"
                    } else if (env.CURRENT_BRANCH == 'main') {
                        sh "docker login -u maruvarasivasu -p yourdockerhubpassword"
                        sh "docker push ${PROD_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully for branch ${env.CURRENT_BRANCH}"
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}
