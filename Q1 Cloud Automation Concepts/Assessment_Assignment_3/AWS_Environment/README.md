# Cloud Automation Concepts - Assessment Assignment 3 - Cloud Orchestration

**Authors**: Ivan Shishkalov, Rudo Steenmans
**Lecturer**: Erik van der Arend

# AWS Environment
This part covers the AWS part of the assignment

## Prerequisites
Before deploying the solution, make sure you follow the checklist below:
- Fresh AWS credentials are set in ~/.aws/credentials
- No conflicting CloudFormation stacks


## Deploy the AWS environment using Terraform

**Note:** The credentials that you pass as variables in the terraform command below will **NOT** be used by Terraform. They have different purpose: they will be passed as parameters to the CloudFormation stacks **DockerSwarmMasterStack** and **DockerSwarmWorkersStack** so that EC2 instances in those stack can utilize AWS CLI in their automation scripts.

**Please make sure you provide fresh credentials**

1. Initialize the Terraform providers

```bash
terraform init
```
2. Plan out Terraform deployment (create an execution plan)

```bash
terraform plan -var aws_access_key_id=<your_aws_access_key_id> -var aws_secret_access_key=<your_aws_secret_access_key> -var aws_session_token=<your_aws_session_token>
```
3. Apply the Terraform changes to reach the desired state of infrastructure (deploy the solution)

```bash
terraform apply --auto-approve -var aws_access_key_id=<your_aws_access_key_id> -var aws_secret_access_key=<your_aws_secret_access_key> -var aws_session_token=<your_aws_session_token>
```
## Clean up the AWS environment using Terraform

1. Ensure your ECR repositories are empty

2. Run

```bash
terraform destroy --auto-approve -var aws_access_key_id=<your_aws_access_key_id> -var aws_secret_access_key=<your_aws_secret_access_key> -var aws_session_token=<your_aws_session_token>
```

