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
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_ID}")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Uruchom kontener w tle
                    bat 'docker run -d --name bmi-container -p 5000:5000 ${DOCKER_IMAGE}:${env.BUILD_ID}'
                    sleep 10 // Czekaj na uruchomienie kontenera
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Testowanie aplikacji
                    def response = bat(script: 'curl -s -o NUL -w "%%{http_code}" -X GET "http://localhost:5000/bmi?weight=70&height=1.75"', returnStdout: true).trim()
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
        always {
            // Zatrzymaj kontener po zakończeniu pipeline
            bat 'docker stop bmi-container || true'
            bat 'docker rm bmi-container || true'
        }
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

