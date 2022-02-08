# Base the image on Ubuntu 20.04 
FROM ubuntu:20.04 

# Image metadata
LABEL maintainer="agustin@dpella.io"
LABEL version="0.1"
LABEL description="development image for DPella engine"

# Set the timezone so apt-get doesn't ask for it later
ENV TZ=Europe/Stockholm
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install base system utilities and dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends software-properties-common sudo ssh git wget curl make lzma liblzma-dev zlib1g-dev

# Install cabal and GHC
RUN add-apt-repository ppa:hvr/ghc
RUN apt-get update
RUN apt-get install -y cabal-install-3.4
RUN apt-get install -y ghc-8.6.5

RUN update-alternatives --install /usr/bin/cabal cabal /opt/cabal/bin/cabal 20
RUN update-alternatives --install /usr/bin/ghc-8.6.5 ghc /opt/ghc/bin/ghc 20
ENV PATH="/opt/ghc/bin:${PATH}"

RUN cabal update

# Make sure we can clone repos from GitHub via SSH
RUN mkdir ~/.ssh
RUN touch ~/.ssh/known_hosts
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

# Install powerline 
RUN apt-get install -y powerline  

# Install less
RUN apt-get install -y less

# Install vim
RUN apt-get install -y vim

# BASHRC for environment variables for GHC and Powerline
COPY ./.bashrc /root/.bashrc

# Move to the root folder
WORKDIR /root

# Clone the DPella repo
#RUN --mount=type=ssh,id=sshkey git clone git@github.com:dpella/engine 

# Build the repo
# RUN cd engine && cabal build all

# Copy the entrypoint script and make it the container's entrypoint
COPY entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint

ENTRYPOINT [ "/bin/entrypoint" ]
