#!/bin/sh

set -e

echo "Reading keys from /tmp/ssh"
cp /tmp/ssh/key /root/.ssh/key
chmod 700 /root/.ssh
chmod 600 /root/.ssh/key

exec /bin/bash --login -c "tmux -2"
