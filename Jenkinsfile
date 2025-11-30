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
