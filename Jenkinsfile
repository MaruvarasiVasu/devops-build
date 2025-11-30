pipeline {
    agent any

    environment {
        PROD_IMAGE = "maruvarasivasu/react-app-prod:latest"
        DOCKER_CRED = 'docker-hub-creds' // Jenkins credential ID for Docker Hub
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/MaruvarasiVasu/devops-build.git'
            }
        }

        stage('Set Branch') {
            steps {
                script {
                    def branchName = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Current branch: ${branchName}"
                }
            }
        }

        stage('Install & Build React App') {
            steps {
                script {
                    // Using Node Docker container to avoid npm issues on host
                    docker.image('node:20-alpine').inside {
                        sh '''
                        npm install
                        npm run build
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${PROD_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CRED}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${PROD_IMAGE}
                        '''
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh '''
                    # Stop & remove old container if exists
                    docker ps -q --filter "name=react-app" | xargs -r docker stop || true
                    docker ps -a -q --filter "name=react-app" | xargs -r docker rm || true

                    # Run new container
                    docker run -d -p 80:80 --name react-app ${PROD_IMAGE}
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    // Simple curl check to ensure app is running
                    sh 'curl -f http://localhost || exit 1'
                    echo "Application is up and running!"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
