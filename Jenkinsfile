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
                script {
                    // Determine branch to build
                    def branchToBuild = env.BRANCH_NAME ?: 'main'
                    echo "Building branch: ${branchToBuild}"
                    
                    // Checkout code
                    git branch: branchToBuild, url: 'https://github.com/MaruvarasiVasu/devops-build.git'
                    
                    env.CURRENT_BRANCH = branchToBuild
                }
            }
        }

        stage('Install Dependencies & Build React App') {
            steps {
                sh 'npm install'
                sh 'npm run build'   // creates build/ folder for Dockerfile
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.CURRENT_BRANCH == 'dev') {
                        echo "Building Docker image for DEV"
                        sh "docker build -t ${DEV_IMAGE} ."
                    } else if (env.CURRENT_BRANCH == 'main') {
                        echo "Building Docker image for PROD"
                        sh "docker build -t ${PROD_IMAGE} ."
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker login -u maruvarasivasu -p yourdockerhubpassword"
                    
                    if (env.CURRENT_BRANCH == 'dev') {
                        echo "Pushing Docker image to DEV repo"
                        sh "docker push ${DEV_IMAGE}"
                    } else if (env.CURRENT_BRANCH == 'main') {
                        echo "Pushing Docker image to PROD repo"
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
