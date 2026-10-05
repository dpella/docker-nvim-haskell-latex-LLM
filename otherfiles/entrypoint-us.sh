#!/bin/sh
# Same as entrypoint.sh, but resolves the home via $HOME instead of a
# hardcoded /root, so it works for the non-root user.

set -e

echo "Reading keys from /tmp/ssh"
cp /tmp/ssh/key "$HOME/.ssh/key"
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/key"

exec /bin/bash --login -c "tmux -2"
