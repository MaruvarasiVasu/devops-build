pipeline {
    agent any
    environment {
        DOCKER_HUB_DEV = "maruvarasivasu/react-app-dev"
        DOCKER_HUB_PROD = "maruvarasivasu/react-app-prod"
    }
    stages {
       stage('Checkout') {
    steps {
        git branch: 'main', url: 'https://github.com/MaruvarasiVasu/devops-build.git'
    }
}
        stage('Build Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker build -t $DOCKER_HUB_DEV:latest ."
                    } else if (env.BRANCH_NAME == 'master') {
                        sh "docker build -t $DOCKER_HUB_PROD:latest ."
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', 
                                                      usernameVariable: 'DOCKER_USER', 
                                                      passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker push $DOCKER_HUB_DEV:latest"
                        } else if (env.BRANCH_NAME == 'master') {
                            sh "docker push $DOCKER_HUB_PROD:latest"
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh "docker stop react-app || true && docker rm react-app || true && docker run -d -p 80:80 --name react-app $DOCKER_HUB_DEV:latest"
                    } else if (env.BRANCH_NAME == 'master') {
                        sh "docker stop react-app || true && docker rm react-app || true && docker run -d -p 80:80 --name react-app $DOCKER_HUB_PROD:latest"
                    }
                }
            }
        }
    }
    post {
        always {
            echo "Pipeline finished for branch ${env.BRANCH_NAME}"
        }
    }
}
