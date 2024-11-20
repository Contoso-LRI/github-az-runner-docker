#!/bin/bash

# Test if required environment variables are set
for var in GH_OWNER_URL GH_RUNNER_NAME GH_TOKEN GH_RUNNER_TAG_NAME; do
    if [ -z "${!var}" ]; then
        echo "ERROR: $var is not set"
        exit 1
    fi
done

# GHToken is a JWT app token and requires to create a registration token for the runner
gh_owner_name=$(echo ${GH_OWNER_URL} | awk -F/ '{print $4}')
reg_token_raw_response = $(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GH_TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/${gh_owner_name}/actions/runners/registration-token)
reg_token=$(echo ${reg_token_raw_response} | jq -r .token)

# Configure the runner
cd /home/docker/actions-runner
echo "Configuring runner for ${GH_OWNER_URL} -- ${GH_RUNNER_NAME}..."
./config.sh --unattended \
            --replace \
            --url ${GH_OWNER_URL} \
            --token ${reg_token} \
            --name ${GH_RUNNER_NAME} \
            --labels ${GH_RUNNER_TAG_NAME},azure,x64,linux

cleanup() {
    echo "Removing runner for ${GH_OWNER_URL} -- ${GH_RUNNER_NAME}..."
    ./config.sh remove --unattended --token ${reg_token}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!