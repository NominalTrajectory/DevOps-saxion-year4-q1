FROM ubuntu:18.04

ENV TERRAFORM_VERSION=0.13.4
ENV PACKER_VERSION=1.3.3
ENV PIP_VERSION=18.1

COPY . /workspace/
RUN cp /workspace/cac-aa3-terraform-credentials.json ~
WORKDIR /workspace

USER root

# Update & Upgrade
RUN apt-get update && apt-get upgrade -y

# Install tools
RUN apt-get install -y curl unzip git jq grep dnsutils 

# Install python and additional tools for python
RUN apt-get install -y python3-pip build-essential libssl-dev libffi-dev python3-dev

# Install ansible
RUN apt-get install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible
    
# Install packer
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && apt-get install -y packer

# Install terraform
RUN apt-get update && apt-get install -y terraform

