pipeline {
    agent any
    environment {
        DOCKER_HUB_MAIN = "maruvarasivasu/react-app-main"
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
                    env.CURRENT_BRANCH = env.BRANCH_NAME ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Current branch: ${env.CURRENT_BRANCH}"
                }
            }
        }

        stage('Install Dependencies & Build React App') {
            steps {
                script {
                    // Check if package.json exists before running npm install
                    def packagePath = fileExists('package.json') ? '.' : 'frontend' // adjust 'frontend' if your folder is different
                    if (!fileExists("${packagePath}/package.json")) {
                        error "package.json not found in root or ${packagePath}"
                    }

                    dir(packagePath) {
                        sh 'npm install'
                        sh 'npm run build'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.CURRENT_BRANCH == 'main') {
                        sh "docker build -t $DOCKER_HUB_MAIN:latest ."
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
                        if (env.CURRENT_BRANCH == 'main') {
                            sh "docker push $DOCKER_HUB_MAIN:latest"
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
                    if (env.CURRENT_BRANCH == 'main') {
                        sh "docker stop react-app || true && docker rm react-app || true && docker run -d -p 80:80 --name react-app $DOCKER_HUB_MAIN:latest"
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
