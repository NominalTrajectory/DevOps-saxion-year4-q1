# Cloud Automation Concepts - Assessment Assignment 3 - Cloud Orchestration

**Authors**: Ivan Shishkalov, Rudo Steenmans
**Lecturer**: Erik van der Arend

# GCP Environment
This part covers the GCP part of the assignment

## Prerequisites
Before deploying the solution, make sure you follow the checklist below:

- You have a GCP project set up and billing enabled
- You have enabled GCP APIs such as Compute Engine API, Container Registry API
- You have Google CLI installed
- You have Docker installed
- You have your Google Service Account credentials in json file
- You have modified the file envrc.sh and replaced values with ones appropriate for you
- You have replaced the cac-aa3-terraform-credentials.json with your own Google credentials file in json and updated the envrc.sh in accordance

**Note:** Other software, such as Terraform, Ansible, Packer and etc is not required to be installed on your workstation, as for cleaniness the deployment will be dedicated to a Docker container that contains all the necessary packages. 


## Deploy the GCP Kubernetes Cluster using Terraform, Packer and Ansible

1. Make sure you're in the GCP_Environment directory and build the Docker container

```bash
docker build -t cac-aa3-deployer:latest .
```
2. Run the docker container and open its CLI


3. Ensure the correctness in the file envrc.sh and expose the necessary environment variables

```bash
bash
source ./envrc.sh
```
4. Build a new GCP image using Packer builder and Ansible playbook (if it fails, run again)

```bash
packer/build.sh
```
5. Initialize the Terraform providers

```bash
terraform init
```
6. Plan out Terraform deployment (create an execution plan)

```bash
terraform plan
```
7. Apply the Terraform changes to reach the desired state of infrastructure (deploy the solution)

```bash
terraform apply --auto-approve
```
## Clean up the AWS environment using Terraform

1. In the deployer docker container run 

```bash
terraform destroy --auto-approve
```
