#!/bin/bash
set -e
source .envrc
packer validate \
    -var zone="$CLOUDSDK_COMPUTE_ZONE" \
    -var project_id="$TF_ADMIN" \
    -var service_account_json="$TF_CREDS" \
    packer/k8s-image.json
packer build \
    -var zone="$CLOUDSDK_COMPUTE_ZONE" \
    -var project_id="$TF_ADMIN" \
    -var service_account_json="$TF_CREDS" \
    packer/k8s-image.json

