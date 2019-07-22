#!/usr/bin/env bash
set -e # Exit immediately when error
set -x # Print a trace of simple commands

DOCKER_REGISTRY_URL='' # with / at the end
container_name=requests_logger

docker=$(which docker)
version=$(cat ./version)

# BUILD NEW DOCKER IMAGE
${docker} build -t ${DOCKER_REGISTRY_URL}${container_name}:latest .
successfully_built_image_id=$(${docker} images | grep "${DOCKER_REGISTRY_URL}${container_name} .* latest " | awk '{print $3}')
${docker} tag ${successfully_built_image_id} ${DOCKER_REGISTRY_URL}${container_name}:${version}

# PUSH IMAGES TO REPO
# ${docker} push ${DOCKER_REGISTRY_URL}${container_name}:latest
# ${docker} push ${DOCKER_REGISTRY_URL}${container_name}:${version}

# REMOVE LOCAL IMAGES
docker images | grep ${container_name}
# ${docker} rmi ${DOCKER_REGISTRY_URL}${container_name}:latest
# ${docker} rmi ${DOCKER_REGISTRY_URL}${container_name}:${version}
