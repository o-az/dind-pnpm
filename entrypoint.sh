#!/bin/bash

set -e

# Start Docker daemon (if not already running)
RUNNING=$(ps -ef | grep dockerd | grep -v grep | awk '{print $2}')
if [ -z "$RUNNING" ]; then
    sudo dockerd > /dev/null 2>&1 &
    disown
fi

tail -f /dev/null