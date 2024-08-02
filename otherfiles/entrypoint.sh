#!/bin/sh

set -e

echo "Reading keys from /tmp/ssh"
cp -r /tmp/ssh/* /root/.ssh/
chmod 700 /root/.ssh
chmod 644 /root/.ssh/key.pub
chmod 600 /root/.ssh/key

exec /bin/bash --login -c "tmux -2"
