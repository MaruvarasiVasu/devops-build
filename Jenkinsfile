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

        stage('Set Branch') {
            steps {
                script {
                    // Determine current branch, fallback if env.BRANCH_NAME is null
                    env.CURRENT_BRANCH = env.BRANCH_NAME ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Current branch: ${env.CURRENT_BRANCH}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.CURRENT_BRANCH == 'dev') {
                        sh "docker build -t $DOCKER_HUB_DEV:latest ."
                    } else if (env.CURRENT_BRANCH == 'master') {
                        sh "docker build -t $DOCKER_HUB_PROD:latest ."
                    } else {
                        echo "Branch ${env.CURRENT_BRANCH} does not trigger Docker build."
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
                        if (env.CURRENT_BRANCH == 'dev') {
                            sh "docker push $DOCKER_HUB_DEV:latest"
                        } else if (env.CURRENT_BRANCH == 'master') {
                            sh "docker push $DOCKER_HUB_PROD:latest"
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    if (env.CURRENT_BRANCH == 'dev') {
                        sh "docker stop react-app || true && docker rm react-app || true && docker run -d -p 80:80 --name react-app $DOCKER_HUB_DEV:latest"
                    } else if (env.CURRENT_BRANCH == 'master') {
                        sh "docker stop react-app || true && docker rm react-app || true && docker run -d -p 80:80 --name react-app $DOCKER_HUB_PROD:latest"
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished for branch ${env.CURRENT_BRANCH}"
        }
    }
}
