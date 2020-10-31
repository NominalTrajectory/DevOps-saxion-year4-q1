# Cloud Automation Concepts - Assessment Assignment 1

**Authors**: Ivan Shishkalov, Rudo Steenmans

**Lecturer**: Erik van der Arend

## Prerequisites

Before deploying the solution, make sure you follow the checklist below:

- Amazon CLI has to be installed
- Fresh AWS credentials are set in ~/.aws/credentials
- Node.js **10.x** is installed on your machine
- Your CloudFormation doesn't have stacks whose names can conflict with the solution: BaseStack, DataLayerStack, EFSStack, WebStack, S3Stack, ELKStack


## Deploy the solution

1. Open a terminal window in the Assessment_Assignment_1 folder
2. Install npm packages

```bash
npm i
```
3. Roll out all the required stacks at once

```bash
npm run deploy
```
4. Don't close the terminal window until all stacks are deployed

## Destroy the solution
1. Open a terminal window in the Assessment_Assignment_1 folder
2. Delete all the stacks at once

```bash
npm run destroy
```
