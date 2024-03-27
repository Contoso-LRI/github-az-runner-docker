FROM ubuntu:22.04

ARG DEBIAN_FRONTEND="noninteractive"
ARG GH_RUNNER_VERSION="2.314.1"
LABEL RunnerVersion=${GH_RUNNER_VERSION}
LABEL BaseImage="ubuntu:22.04"

# Add a non-sudo user
RUN useradd -m docker

# update the base packages
RUN apt-get update -y && apt-get upgrade -y

# install the packages and dependencies along with jq so we can parse JSON (add additional packages as necessary)
RUN apt-get install --no-install-recommends -qqy \
    curl \
    nodejs \
    wget \
    unzip \
    git \
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    gnupg \
    software-properties-common

# install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# cd into the user directory, download and unzip the github actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# add over the start.sh script
ADD scripts/start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]