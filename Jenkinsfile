pipeline { 
    agent any
    environment {
        GCR_CREDENTIALS_ID = 'gcr_jenkins_key'
        IMAGE_NAME = 'niles/test-build-1'
        GCR_URL = 'gcr.io/lbg-mea-build-c19'
        PROJECT_ID = 'lbg-mea-build-c19'
        CLUSTER_NAME = 'niles-cluster'
        LOCATION = 'europe-west2-c'
        K8S_CREDENTIALS_ID = 'gcr_kubernetes_key'
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
                    sh "docker build -t ${GCR_URL}/${IMAGE_NAME}:latest ."
                }
            }
        }
        stage('Push step') {
            steps {
                script {
                    // Push the Docker image to GCR
                    sh "docker push ${GCR_URL}/${IMAGE_NAME}:latest"
                }
            }
        }
        stage('Deploy to GKE') {
            steps {
                script {
                    // Deploy to GKE using Jenkins Kubernetes Engine Plugin
                    step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'kubernetes/deployment.yml', credentialsId: env.K8S_CREDENTIALS_ID, verifyDeployments: true])
                }
            }
        }
    }
}