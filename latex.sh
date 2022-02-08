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
docker volume ls | grep ${IMAGE} 

if [ $? == 0 ]; then 
	echo "Volume already exists" 
else
	echo "Creating volume!"
	docker volume create ${IMAGE} 
fi 

echo "Launching the container..."

docker run --rm -it -v $(pwd)/ssh:/tmp/ssh:ro -v ${IMAGE}:/vol ${IMAGE}:devel
