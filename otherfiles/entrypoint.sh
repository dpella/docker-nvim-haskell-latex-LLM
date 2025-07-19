#!/bin/sh

set -e

echo "Reading keys from /tmp/ssh"
cp /tmp/ssh/key /root/.ssh/key
chmod 700 /root/.ssh
chmod 600 /root/.ssh/key

ANTHROPIC=$(cat /tmp/ssh/antropic_key) 
OPENAI=$(cat /tmp/ssh/openai_key)
echo "export ANTHROPIC_API_KEY=${ANTHROPIC}" >> ~/.bashrc 
echo "export OPENAI_API_KEY=${OPENAI}" >> ~/.bashrc 

exec /bin/bash --login -c "tmux -2"
