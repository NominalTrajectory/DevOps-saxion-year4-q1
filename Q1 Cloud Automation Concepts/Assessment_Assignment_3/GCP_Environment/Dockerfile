FROM ubuntu:18.04

RUN apt-get update && apt-get -y install sudo
RUN useradd -ms /bin/bash ubuntu
RUN sudo adduser ubuntu sudo
RUN echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu/workspace 
COPY . /home/ubuntu/workspace
RUN cp /home/ubuntu/workspace/cac-aa3-terraform-credentials.json ~

# Update & Upgrade
RUN sudo apt-get update && sudo apt-get upgrade -y

# Install tools
RUN sudo apt-get install -y curl unzip git jq grep dnsutils 

# Install python and additional tools for python
RUN sudo apt-get install -y python3-pip build-essential libssl-dev libffi-dev python3-dev

# Install ansible
RUN sudo apt-get install -y software-properties-common && \
    sudo apt-add-repository --yes --update ppa:ansible/ansible && \
    sudo apt-get install -y ansible
    
# Install packer
RUN sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    sudo apt-get update && sudo apt-get install -y packer

# Install terraform
RUN sudo apt-get update && sudo apt-get install -y terraform

# Generating SSH key for GCP (project-wide), will be pushed by terraform
RUN mkdir /home/ubuntu/.ssh && ssh-keygen -t rsa -f /home/ubuntu/.ssh/gcp -C ubuntu


RUN sudo chmod +x /home/ubuntu/workspace/envrc.sh
RUN sudo chmod +x /home/ubuntu/workspace/packer/build.sh
RUN sudo chmod +x /home/ubuntu/workspace/scripts/kubeadm-token.sh
RUN sudo chmod +x /home/ubuntu/workspace/scripts/kubeadm-setup.sh
RUN sudo chmod +x /home/ubuntu/workspace/scripts/covid-services-build-server-setup.sh
RUN sudo chmod +x /home/ubuntu/workspace/scripts/covid-services-single-node-setup.sh
RUN . /home/ubuntu/workspace/envrc.sh




