# Cloud Automation Concepts - Assessment Assignment 3 - Cloud Orchestration

**Authors**: Ivan Shishkalov, Rudo Steenmans
**Lecturer**: Erik van der Arend

# AWS Environment
This part covers the AWS part of the assignment

## Prerequisites
Before deploying the solution, make sure you follow the checklist below:
- Fresh AWS credentials are set in ~/.aws/credentials


## Deploy the AWS environment using Terraform

**Note:** The credentials that you pass as variables in the terraform command below will **NOT** be used by Terraform. They have different purpose: they will be passed as parameters to the CloudFormation stacks **DockerSwarmMasterStack** and **DockerSwarmWorkersStack** so that EC2 instances in those stack can utilize AWS CLI in their automation scripts.

**Please make sure you provide fresh credentials**

```bash
terraform init
```

```bash
terraform apply -var aws_access_key_id=<your aws_access_key_id> -var aws_secret_access_key=<your aws_secret_access_key> -var aws_session_token=<your aws_session_token>
```




