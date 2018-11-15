#!/usr/bin/env bash
set +e # Error out when a command returns error
set -x # Print out commands before executing them

container_name=requests_logger
container_instance=${container_name}___CONTAINER_BUILD___${BUILD_NUMBER}
container_instances=${container_name}___CONTAINER_BUILD___

docker=$(which docker)
latest_tag=$(cat ./version)

if [ ! -z "$(docker ps | grep ${container_instances})" ];then
  docker ps | grep ${container_instances} | cut -d " " -f 1 | xargs docker kill
fi

if [ ! -z "$(docker ps -a | grep ${container_instances})" ];then
  docker ps -a | grep ${container_instances} | cut -d " " -f 1 | xargs docker rm
fi

# BUILD NEW CONTAINER - TMP
${docker} build -t hub.int.proofhq.com:5000/${container_name}:tmp .

successfully_built_image_id=$(${docker} images | grep "${DOCKER_REGISTRY_URL}/${container_name} .* tmp " | awk '{print $3}')
#${docker} tag -f ${successfully_built_image_id} hub.int.proofhq.com:5000/${container_name}:latest
#${docker} tag -f ${successfully_built_image_id} hub.int.proofhq.com:5000/${container_name}:${latest_tag}
#
#${docker} push hub.int.proofhq.com:5000/${container_name}:latest
#${docker} push hub.int.proofhq.com:5000/${container_name}:${latest_tag}
#
#if [ ! -z "$(docker ps | grep ${container_instances})" ];then
#  docker ps | grep ${container_instances} | cut -d " " -f 1 | xargs docker kill
#fi
#
#if [ ! -z "$(docker ps -a | grep ${container_instances})" ];then
#  docker ps -a | grep ${container_instances} | cut -d " " -f 1 | xargs docker rm
#fi
#
#docker ps
#docker images
#
#${docker} rmi hub.int.proofhq.com:5000/${container_name}:tmp
#${docker} rmi hub.int.proofhq.com:5000/${container_name}:latest
#${docker} rmi hub.int.proofhq.com:5000/${container_name}:${latest_tag}
#
#rm -f ./Gemfile
