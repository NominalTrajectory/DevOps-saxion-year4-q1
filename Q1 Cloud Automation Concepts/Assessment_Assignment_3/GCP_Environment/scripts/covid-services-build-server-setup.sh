#!/bin/bash
cd ~
echo 'https://test.com' >> apiEndpoint
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install -y docker-ce git
sudo systemctl start docker
sudo systemctl enable docker
gcloud auth activate-service-account cac-aa3-terraform@cac-aa3-cloud-orchestration.iam.gserviceaccount.com --key-file=/home/ubuntu/cac-aa3-terraform-credentials.json
yes | gcloud auth configure-docker
git clone https://github.com/BFL-Psycho/cac-aa2-covid-dashboard-docker.git
cp apiEndpoint cac-aa2-covid-dashboard-docker/
cd cac-aa2-covid-dashboard-docker && sudo docker build -t covid-dashboard:latest .
sudo docker tag covid-dashboard:latest eu.gcr.io/cac-aa3-cloud-orchestration/covid-dashboard
sudo docker push eu.gcr.io/cac-aa3-cloud-orchestration/covid-dashboard
cd ~
git clone https://github.com/BFL-Psycho/cac-aa2-covid-registration-form-docker.git
cd cac-aa2-covid-registration-form-docker && sudo docker build -t covid-form:latest .
sudo docker tag covid-form:latest eu.gcr.io/cac-aa3-cloud-orchestration/covid-form
sudo docker push eu.gcr.io/cac-aa3-cloud-orchestration/covid-form