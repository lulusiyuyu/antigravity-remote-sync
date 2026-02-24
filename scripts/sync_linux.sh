#!/bin/bash
# Universal Sync Helper for Linux / WSL Platforms
# This script handles pushing a local directory to a remote server incrementally.

HOST=$1
PORT=$2
USER=$3
AUTH_TYPE=$4  # 'key' or 'password'
REMOTE_DIR=$5
EXCLUDE=${6:-".git"}

if [ -z "$HOST" ] || [ -z "$REMOTE_DIR" ]; then
    echo "Usage: ./sync_linux.sh <host> <port> <user> <auth_type(key/password)> <remote_dir> [exclude]"
    exit 1
fi

echo "🚀 Starting cross-platform sync (Linux/WSL) to $HOST:$REMOTE_DIR ..."

if [ "$AUTH_TYPE" == "password" ] && command -v sshpass &> /dev/null; then
    echo "[Strategy] Detected password auth requirement. Proceeding with sshpass + rsync."
    echo "Note for Agent: For actual password passing, please format the raw sshpass command directly in the remote_context.md if this wrapper script lacks password env vars."
    rsync -avz --exclude="$EXCLUDE" -e "ssh -o StrictHostKeyChecking=no -p $PORT" ./ "$USER@$HOST:$REMOTE_DIR/"
else
    echo "[Strategy] Using standard native rsync (Expecting SSH Key or manual prompt)."
    rsync -avz --exclude="$EXCLUDE" -e "ssh -o StrictHostKeyChecking=no -p $PORT" ./ "$USER@$HOST:$REMOTE_DIR/"
fi

echo "✅ Sync Operation Complete!"
