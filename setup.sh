#!/bin/bash

#Exit script if any command fails
set -e

#Define Docker image name
DOCKER_IMAGE="lbg_image"
DOCKER_CONTAINER="lbg_container"

#Function to clean up previous build artifacts
cleanup() {
    echo "Cleaning up previous build artifacts..."
    sleep 3
    docker stop $(docker ps -q) || true
    docker rm -f $(docker ps -qa) || true
    docker rmi -f $(docker images -q) || true
    echo "Cleanup done."
}

#Function to build the Docker image
build_docker() {
    echo "Building the Docker image..."
    sleep 3
    docker build -t $DOCKER_IMAGE .
}

#Function to modify the application
modify_app() {
    echo "Modifying the application..."
    sleep 3
    export PORT=1986
    echo "Modifications done. Port is now set to $PORT"
}

#Function to run the Docker container
run_docker() {
    echo "Running Docker container..."
    sleep 3
    docker run -d -p 80:$PORT -e PORT=$PORT --name $DOCKER_CONTAINER $DOCKER_IMAGE
}

#Main script execution
echo "Starting build process..."
sleep 3
cleanup
build_docker
modify_app
build_docker
run_docker
echo "Build process completed successfully"