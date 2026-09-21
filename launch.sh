#!/bin/bash



IMAGE=$1 
IMAGES=$(find dockerfiles/ -name "*.docker"  -printf "%f\n" | awk -F. '{ print $1 }')

show_images() {
	echo "Available images are:" $IMAGES
	exit 1
}

## Missing argument 
if [ $# -eq 0 ]; then
	echo "Missing name of the image to create or container to launch!"
	show_images
	exit 1
fi

## Argument given, check that is a right one 
if [ $# -eq 1 ]; then
	echo $IMAGES | grep -w $IMAGE > /dev/null  
	if [ $? -ne 0 ]; then 
		echo "Name of the image to create or container to launch is not known!"
		echo "The name should be one of these:"
		show_images
		exit 1
	fi
fi

# Checking if the image exists  
docker images | grep ${IMAGE} 

if [ $? -eq 0 ]; then 
	echo "Image already exists!"
else
	echo "Building the image..."
	docker build -f ./dockerfiles/${IMAGE}.docker . --tag ${IMAGE}:devel
fi 

# Checking if an associated volume exists 
docker volume ls | grep ${IMAGE} 

if [ $? -eq 0 ]; then 
	echo "Volume already exists" 
else
	echo "Creating volume!"
	docker volume create ${IMAGE} 
fi 

echo "Launching the container..."


PORT_OPTION=""

if [ "${IMAGE}" = "neo-h" ]; then
    PORT_OPTION="-p 0.0.0.0:8000:8000 -p 0.0.0.0:2222:2222 -p 0.0.0.0:8080:8080"
fi

# Assign half of the host CPUs to the container
TOTAL_CPUS=$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN)
CONTAINER_CPUS=$(( TOTAL_CPUS / 2 ))
[ "${CONTAINER_CPUS}" -lt 1 ] && CONTAINER_CPUS=1
# Docker rejects --cpus above what its engine sees (e.g. Docker Desktop's VM)
DOCKER_CPUS=$(docker info --format '{{.NCPU}}' 2>/dev/null)
if [ -n "${DOCKER_CPUS}" ] && [ "${DOCKER_CPUS}" -gt 0 ] 2>/dev/null && [ "${CONTAINER_CPUS}" -gt "${DOCKER_CPUS}" ]; then
	CONTAINER_CPUS=${DOCKER_CPUS}
fi
echo "Detected ${TOTAL_CPUS} CPUs - assigning ${CONTAINER_CPUS} to the container"

docker run --rm \
	   -d   \
	   --cpus="${CONTAINER_CPUS}" \
           -it  \
	   -v $(pwd)/ssh:/tmp/ssh:ro \
	   -v ${IMAGE}:/vol  \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /mnt/wslg:/mnt/wslg \
	   -v /var/run/docker.sock:/var/run/docker.sock \
	   -v /usr/bin/docker:/usr/bin/docker \
	   -e "TERM=xterm-256color" \
           -e DISPLAY \
           -e WAYLAND_DISPLAY \
           -e XDG_RUNTIME_DIR \
           -e PULSE_SERVER \
	   ${PORT_OPTION} \
           ${IMAGE}:devel


