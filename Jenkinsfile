pipeline { 
    agent any
    environment {
        GCR_CREDENTIALS_ID = 'gcr_jenkins_key'
        IMAGE_NAME = 'nile/test-build-1'
        GCR_URL = 'gcr.io/lbg-mea-build-c19'
    }
    stages {
        stage('Authenticate step') {
            steps {
                script {
                    // Authenticate with Google Cloud 
                    withCredentials([file(credentialsId: GCR_CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                        }
                    // Configure Docker to use gcloud as a credential helper
                    sh 'gcloud auth configure-docker --quiet'
                }
            }
        }
        stage('Build step') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${GCR_URL}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }
        stage('Push step') {
            steps {
                script {
                    // Push the Docker image to GCR
                    sh "docker push ${GCR_URL}/${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }
    }
}