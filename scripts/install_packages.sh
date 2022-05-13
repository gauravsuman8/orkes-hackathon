#!/usr/bin/env bash
set -e -x -a
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get -y update && apt-get -y install python3-pip unzip docker.io helm
