#!/bin/bash

IMAGE="latex"

# Checking if the image exists  
docker images | grep ${IMAGE} 

if [ $? == 0 ]; then 
	echo "Image already exists!"
else
	echo "Building the image..."
	docker build -f ./dockerfiles/${IMAGE}.docker . --tag ${IMAGE}:devel
fi 

# Checking if an associated volume exists 
docker volume ls | grep ${IMAGE} > /dev/null 

if [ $? == 0 ]; then 
	echo "Volume already exists" 
else
	echo "Creating volume!"
	docker volume create ${IMAGE} 
fi 

# Checking if the container is already up 
docker container ls | grep ${IMAGE} > /dev/null

if [ $? == 0 ]; then 
	echo "Container is already up!" 
else
	echo "Launching the container..."
	docker run --rm -d -it -v $(pwd)/ssh:/tmp/ssh:ro -v ${IMAGE}:/vol ${IMAGE}:devel
fi
