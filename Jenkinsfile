pipeline {
    agent any

    environment {
        DEV_IMAGE = "maruvarasivasu/react-app-dev:latest"
        PROD_IMAGE = "maruvarasivasu/react-app-prod:latest"
        DOCKER_USER = credentials('docker-username')  // Jenkins credential ID for Docker username
        DOCKER_PASS = credentials('docker-password')  // Jenkins credential ID for Docker password
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
                sh '''
                npm install
                npm run build
                '''
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
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
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
                    # Stop and remove old container if exists
                    docker ps -q --filter "name=react-app" | xargs -r docker stop
                    docker ps -a -q --filter "name=react-app" | xargs -r docker rm

                    # Run new container
                    docker run -d -p 80:80 --name react-app ${PROD_IMAGE}
                    '''
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
