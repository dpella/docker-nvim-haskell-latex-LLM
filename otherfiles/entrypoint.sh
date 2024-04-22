#!/bin/sh

set -e

echo "Reading keys from /tmp/ssh"
cp -r /tmp/ssh/* /root/.ssh/
chmod 700 /root/.ssh
chmod 644 /root/.ssh/key.pub
chmod 600 /root/.ssh/key

# Plugin for neo-vim and Haskell
# apt-get install -y luarocks 
# luarocks install haskell-tools.nvim

exec /bin/bash
