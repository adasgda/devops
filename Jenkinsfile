pipeline {
    agent any

    environment {
        REPO = 'https://github.com/adasgda/devops.git'
        BRANCH = 'main'
        DOCKER_IMAGE = 'bmi-image'
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
                    docker.build(env.DOCKER_IMAGE)
                }
        }
    }
        stage('Run Docker Compose') {
            steps {
                script {
                    docker.image("${env.DOCKER_IMAGE}:latest").run("-p 5000:5000")
                }
            }
        }

      stage('Test') {
            steps {
                script {
                    // Testowanie aplikacji
                    def isUnix = isUnix()
                    def response

                    if (isUnix) {
                        response = sh(script: 'curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:5000/bmi -H "Content-Type: application/json" -d \'{"weight": 70, "height": 1.75}\'', returnStdout: true).trim()
                    } else {
                        response = bat(script: 'curl -s -o NUL -w "%%{http_code}" -X POST http://localhost:5000/bmi -H "Content-Type: application/json" -d "{\\"weight\\": 70, \\"height\\": 1.75}"', returnStdout: true).trim()
                    }

                    if (response != '200') {
                        error "Test failed with response code ${response}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
            }
        }
    }

    post {
        failure {
            emailext (
                subject: "Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) failed",
                body: "Please see the console output for more details.",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }

        success {
            emailext (
                subject: "Job '${env.JOB_NAME}' (${env.BUILD_NUMBER}) succeeded",
                body: "Build and deployment were successful.",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
    }
}
