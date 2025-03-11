#!/bin/bash

# Test if required environment variables are set
for var in GH_OWNER_URL GH_RUNNER_NAME GH_TOKEN GH_RUNNER_TAG_NAME; do
    if [ -z "${!var}" ]; then
        echo "ERROR: $var is not set"
        exit 1
    fi
done

# Configure the runner
cd /home/docker/actions-runner
echo "Configuring runner for ${GH_OWNER_URL} -- ${GH_RUNNER_NAME}..."
./config.sh --unattended \
            --replace \
            --url ${GH_OWNER_URL} \
            --token ${GH_TOKEN} \
            --name ${GH_RUNNER_NAME} \
            --labels ${GH_RUNNER_TAG_NAME},azure,x64,linux

cleanup() {
    echo "Removing runner for ${GH_OWNER_URL} -- ${GH_RUNNER_NAME}..."
    ./config.sh remove --unattended --token ${GH_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
