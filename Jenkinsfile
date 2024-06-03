pipeline {
    agent any

    environment {
        REPO = 'https://github.com/adasgda/devops.git'
        BRANCH = 'main'
        DOCKER_IMAGE = 'bmi-app-image'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Run Docker Compose') {
            steps {
                sh 'docker-compose up -d'
            }
        }

        stage('Test') {
            steps {
                script {
                    def response = sh(script: 'curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:5000/bmi -H "Content-Type: application/json" -d \'{"weight": 70, "height": 1.75}\'', returnStdout: true).trim()
                    if (response != '200') {
                        error "Test failed with response code ${response}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                echo 'Loading...'
                echo 'Success...'
            }
        }
    }

    post {
        failure {
            emailext (
                subject: "Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) failed",
                body: "Please see the console for more details.",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }

        success {
            emailext (
                subject: "Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) succeeded",
                body: "Successful build and deployment environment.",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
    }
}
