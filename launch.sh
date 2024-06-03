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

echo "Setting up the clipboard to get messages from the container ..." 

if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then
	# Start up the socat forwarder to clip.exe
        ALREADY_RUNNING=$(ps -auxww | grep -q "[l]isten:8121"; echo $?)
        if [[ $ALREADY_RUNNING != "0" ]]; then
            echo "Starting clipboard relay..."
            (setsid socat tcp-listen:8121,fork,bind=0.0.0.0 EXEC:'clip.exe' &) > /dev/null 2>&1 
        else
	    echo "Clipboard relay already running"
       fi
fi

echo "Launching the container..."

docker run --rm \
	   -d   \
	   --cpus="8" \
           -it  \
	   -v $(pwd)/ssh:/tmp/ssh:ro \
	   -v ${IMAGE}:/vol  \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /mnt/wslg:/mnt/wslg \
           -e DISPLAY \
           -e WAYLAND_DISPLAY \
           -e XDG_RUNTIME_DIR \
           -e PULSE_SERVER \
           ${IMAGE}:devel


