#!/bin/bash
export TF_ADMIN="cac-aa3-cloud-orchestration"
export TF_CREDS="~/workspace/cac-aa3-terraform-credentials.json"
export GOOGLE_PROJECT=${TF_ADMIN}
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_CLOUD_KEYFILE_JSON=${TF_CREDS}
export CLOUDSDK_COMPUTE_REGION="europe-west4"
export CLOUDSDK_COMPUTE_ZONE="europe-west4-b"
export TF_VAR_project=${TF_ADMIN}
export TF_VAR_region=${CLOUDSDK_COMPUTE_REGION}
export TF_VAR_zone=${CLOUDSDK_COMPUTE_ZONE}
export TF_VAR_ssh_public_key="~/.ssh/gcp.pub"
export TF_VAR_ssh_private_key="~/.ssh/gcp"
export TF_VAR_ssh_user="ubuntu"
export TF_VAR_admin_wan_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)

