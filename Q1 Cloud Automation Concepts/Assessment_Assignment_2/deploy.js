//  `8.`888b           ,8' .8.          8 888888888o.    8 8888          .8.          8 888888888o   8 8888         8 8888888888     d888888o.
//   `8.`888b         ,8' .888.         8 8888    `88.   8 8888         .888.         8 8888    `88. 8 8888         8 8888         .`8888:' `88.
//    `8.`888b       ,8' :88888.        8 8888     `88   8 8888        :88888.        8 8888     `88 8 8888         8 8888         8.`8888.   Y8
//     `8.`888b     ,8' . `88888.       8 8888     ,88   8 8888       . `88888.       8 8888     ,88 8 8888         8 8888         `8.`8888.
//      `8.`888b   ,8' .8. `88888.      8 8888.   ,88'   8 8888      .8. `88888.      8 8888.   ,88' 8 8888         8 888888888888  `8.`8888.
//       `8.`888b ,8' .8`8. `88888.     8 888888888P'    8 8888     .8`8. `88888.     8 8888888888   8 8888         8 8888           `8.`8888.
//        `8.`888b8' .8' `8. `88888.    8 8888`8b        8 8888    .8' `8. `88888.    8 8888    `88. 8 8888         8 8888            `8.`8888.
//         `8.`888' .8'   `8. `88888.   8 8888 `8b.      8 8888   .8'   `8. `88888.   8 8888      88 8 8888         8 8888        8b   `8.`8888.
//          `8.`8' .888888888. `88888.  8 8888   `8b.    8 8888  .888888888. `88888.  8 8888    ,88' 8 8888         8 8888        `8b.  ;8.`8888
//           `8.` .8'       `8. `88888. 8 8888     `88.  8 8888 .8'       `8. `88888. 8 888888888P   8 888888888888 8 888888888888 `Y8888P ,88P'

//Description: Importing of non AWS npm packages
const fs = require("fs");
const { exit } = require("process");
const { error } = require("console");
const { performance } = require("perf_hooks");
const sleep = (waitTimeInMs) =>
  new Promise((resolve) => setTimeout(resolve, waitTimeInMs));

//Description: Importing of the AWS npm packages
const AWS = require("aws-sdk");
const { CodeDeploy } = require("aws-sdk");
const { SSL_OP_EPHEMERAL_RSA } = require("constants");

//Description: define the AWS credentails:
const credentials = new AWS.SharedIniFileCredentials({
  profile: "default",
});
AWS.config.credentials = credentials;
AWS.config.update({ region: "us-east-1" });
AWS.config.apiVersions = { lambda: "2015-03-31" };

//Description: Instantiating AWS API classes
const CFN = new AWS.CloudFormation();
const LAMBDA = new AWS.Lambda();

//Description: Read the stack template files into variables
const BASE_NETWORK_STACK_TEMPLATE = fs.readFileSync(
  "./1-BaseStack/aa2_base_network.yml"
);
const DATA_LAYER_STACK_TEMPLATE = fs.readFileSync(
  "./2-DataLayerStack/aa2_data_layer_stack.yml"
);
const ECR_STACK_TEMPLATE = fs.readFileSync(
  "./4-ECRStack/cac_aa2_ecr_stack.yml"
);
const DOCKER_SWARM_MASTER_STACK_TEMPLATE = fs.readFileSync(
  "./5-MasterDockerSwarmStack/cac_aa2_docker_swarm_master.yml"
);
const DOCKER_SWARM_WORKERS_STACK_TEMPLATE = fs.readFileSync(
  "./6-WorkerDockerSwarmStack/cac_aa2_docker_swarm_workers.yml"
);

//Description: Read buffer from zip archives with Lambda functions code into variables
const CACAA2MongoDBDataRefresherZip = fs.readFileSync(
  "./3-Lambdas/MongoDBDataRefresher/MongoDBDataRefresher.zip"
);
const CACAA2MongoDBDataRetrieverZip = fs.readFileSync(
  "./3-Lambdas/MongoDBDataRetriever/MongoDBDataRetriever.zip"
);

//Description: Start timer by writing System time to t0
let t0 = performance.now();

//  8 8888888888   8 8888      88 b.             8     ,o888888o. 8888888 8888888888  8 8888     ,o888888o.     b.             8    d888888o.
//  8 8888         8 8888      88 888o.          8    8888     `88.     8 8888        8 8888  . 8888     `88.   888o.          8  .`8888:' `88.
//  8 8888         8 8888      88 Y88888o.       8 ,8 8888       `8.    8 8888        8 8888 ,8 8888       `8b  Y88888o.       8  8.`8888.   Y8
//  8 8888         8 8888      88 .`Y888888o.    8 88 8888              8 8888        8 8888 88 8888        `8b .`Y888888o.    8  `8.`8888.
//  8 888888888888 8 8888      88 8o. `Y888888o. 8 88 8888              8 8888        8 8888 88 8888         88 8o. `Y888888o. 8   `8.`8888.
//  8 8888         8 8888      88 8`Y8o. `Y88888o8 88 8888              8 8888        8 8888 88 8888         88 8`Y8o. `Y88888o8    `8.`8888.
//  8 8888         8 8888      88 8   `Y8o. `Y8888 88 8888              8 8888        8 8888 88 8888        ,8P 8   `Y8o. `Y8888     `8.`8888.
//  8 8888         ` 8888     ,8P 8      `Y8o. `Y8 `8 8888       .8'    8 8888        8 8888 `8 8888       ,8P  8      `Y8o. `Y8 8b   `8.`8888.
//  8 8888           8888   ,d8P  8         `Y8o.`    8888     ,88'     8 8888        8 8888  ` 8888     ,88'   8         `Y8o.` `8b.  ;8.`8888
//  8 8888            `Y88888P'   8            `Yo     `8888888P'       8 8888        8 8888     `8888888P'     8            `Yo  `Y8888P ,88P'

//Trigger the deployment process
deploy();





/*Descrition: This is the Deploy function, it is called at the start of the program and starts the deployment of the solution by first deploying the BaseStack and after that is complete 
              it calls the functions that build the EFSStack, the DataLayerStack and the S3Stack */
function deploy() {
  console.log(
    `Deploying the BaseStack with network configuration. Please wait (~5 min)...`
  );
  return CFN.createStack(
    (params = {
      StackName: "BaseStack",
      TemplateBody: `${BASE_NETWORK_STACK_TEMPLATE}`, //Var: BASE_NETWORK_STACK_TEMPLATE          (The location of the BaseStack yml file)
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
        //Wait for BaseStack deployment to complete
        CFN.waitFor(
          "stackCreateComplete",
          (params = {
            StackName: "BaseStack",
          }),
          (err, data) => {
            if (err) {
              console.warn(err);
              process.exit(1);
            } else {
              console.log(`BaseStack has been successfully deployed.`);
              deployDataLayerStack(); //Fun: deployDataLayerStack               (The function that deploys the DataLayerStack)
            }
          }
        );
      }
    }
  );
}

function deployECRStack() {
  console.log(
    `Deploying the ECRStack with two repositories for images of Covid Dashboard and Covid Registration Form (~3 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "ECRStack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${ECR_STACK_TEMPLATE}`,
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
        //Wait for EFSStack deployment to complete
        CFN.waitFor(
          "stackCreateComplete",
          (params = {
            StackName: "ECRStack",
          }),
          (err, data) => {
            if (err) {
              console.warn(err);
              process.exit(1);
            } else {
              console.log(`ECRStack has been successfully deployed.`);
              deployDockerSwarmMasterStack();
              invokeDataRefresher();
            }
          }
        );
      }
    }
  );
}

/*Descrition: This is the deployDataLayerStack function, it is called by the deploy function of the program and starts the deployment of the DataLayerStack and runs parales with the functions that 
              build the EFSStack and the S3Stack, ending with a message to the console alerting the user the deployment is complete. But like the deploy function that deployed the BaseStack
              this function also calls the function that build the WebStack and also two other functions that uploads the code for the Lambda functions  */
function deployDataLayerStack() {
  console.log(
    `Deploying the DataLayerStack with MongoDB, REST API and underlying Lambda functions. Please wait (~5 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "DataLayerStack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${DATA_LAYER_STACK_TEMPLATE}`, //Var: DATA_LAYER_STACK_TEMPLATE          (The location of the DataLayerStack yml file)
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
        CFN.waitFor(
          //Wait for DataLayerStack deployment to complete
          "stackCreateComplete",
          (params = {
            StackName: "DataLayerStack",
          }),
          (err, data) => {
            if (err) {
              console.warn(err);
              process.exit(1);
            } else {
              console.log(`DataLayerStack has been successfully deployed.`);
              console.log(
                `Uploading the supportive Lambda functions code from local zip-files. Please wait (~2 min)...`
              );
              uploadCACAA2MongoDBDataRefresherCode(); //Fun: uploadCACAA2MongoDBDataRefresherCode   (The function that uploads the code for the CACAA2MongoDBDataRefresher Lambda function)
              uploadCACAA2MongoDBDataRetrieverCode(); //Fun: uploadCACAA2MongoDBDataRetrieverCode   (The function that uploads the code for the CACAA2MongoDBDataRetriever Lambda function)
              deployECRStack();
            }
          }
        );
      }
    }
  );
}

/*Descrition: This is the deployWebStack function, it is called by the deployDataLayerStack function of the program and starts the deployment of the WebStack, ending with a message 
              to the console alerting the user the deployment is complete or has failed */
function deployDockerSwarmMasterStack() {
  console.log(
    `Deploying the DockerSwarmMasterStack with BuildServer01. Please wait (~5 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "DockerSwarmMasterStack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${DOCKER_SWARM_MASTER_STACK_TEMPLATE}`,
      Parameters: [
        {
          ParameterKey: 'AWSAccessKeyId',
          ParameterValue: AWS.config.credentials.accessKeyId
        },
        {
          ParameterKey: 'AWSSecretAccessKey',
          ParameterValue: AWS.config.credentials.secretAccessKey
        },
        {
          ParameterKey: 'AWSSessionToken',
          ParameterValue: AWS.config.credentials.sessionToken
        }
      ]
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
        CFN.waitFor(
          "stackCreateComplete",
          (params = {
            StackName: "DockerSwarmMasterStack",
          }),
          (err, data) => {
            if (err) {
              console.warn(err);
              process.exit(1);
            } else {
              console.log(
                `DockerSwarmMasterStack has been successfully deployed.`
              );
              console.log(
                `Waiting for the BuildServer to initialize and send the join-token... (~10 min)`
              );
              //Wait 10 minutes for BuildServer to initialize and send out the join token to DynamoDB, then deploy Workers
              sleep(600000).then(() => {
                deployDockerSwarmWorkersStack();
              });
            }
          }
        );
      }
    }
  );
}

function deployDockerSwarmWorkersStack() {
  console.log(
    `Deploying the DockerSwarmWorkersStack with Worker Nodes running the covid-services stack in a global mode. Please wait (~5 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "DockerSwarmWorkersStack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${DOCKER_SWARM_WORKERS_STACK_TEMPLATE}`,
      Parameters: [
        {
          ParameterKey: 'AWSAccessKeyId',
          ParameterValue: AWS.config.credentials.accessKeyId
        },
        {
          ParameterKey: 'AWSSecretAccessKey',
          ParameterValue: AWS.config.credentials.secretAccessKey
        },
        {
          ParameterKey: 'AWSSessionToken',
          ParameterValue: AWS.config.credentials.sessionToken
        }
      ]
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
        CFN.waitFor(
          "stackCreateComplete",
          (params = {
            StackName: "DockerSwarmWorkersStack",
          }),
          (err, data) => {
            if (err) {
              console.warn(err);
              process.exit(1);
            } else {
              console.log(
                `DockerSwarmWorkersStack has been successfully deployed.`
              );
              let t1 = performance.now();
              console.info(
                `Deployment completed successfully! Total time elapsed: ${(
                  (t1 - t0) /
                  60000
                ).toFixed(2)} min.`
              );
              return true;
            }
          }
        );
      }
    }
  );
}

/*Descrition: This is the uploadCACAA2MongoDBDataRefresherCode function, it is called by the deployDataLayerStack function of the program and uplaods the code for the CACAA2MongoDBDataRefresher 
              Lambda function of the WebStack, ending with a message to the console alerting the user the upload is complete or has failed */
function uploadCACAA2MongoDBDataRefresherCode() {
  LAMBDA.updateFunctionCode(
    (params = {
      FunctionName: "CACAA2MongoDBDataRefresher",
      ZipFile: CACAA2MongoDBDataRefresherZip, //Var: CACAA2MongoDBDataRefresherZip      (The location of the CACAA2MongoDBDataRefresher code for the Lambda function of the same name in the zip file)
    }),
    (err, data) => {
      if (err) {
        console.log(err);
      } else {
        console.log(
          "CACAA2MongoDBDataRefresher Lambda code has been successfully uploaded."
        );
      }
    }
  );
}

/*Descrition: This is the uploadCACAA2MongoDBDataRetrieverCode function, it is called by the deployDataLayerStack function of the program and uplaods the code for the CACAA2MongoDBDataRetriever 
              Lambda function of the WebStack, ending with a message to the console alerting the user the upload is complete or has failed */
function uploadCACAA2MongoDBDataRetrieverCode() {
  LAMBDA.updateFunctionCode(
    (params = {
      FunctionName: "CACAA2MongoDBDataRetriever",
      ZipFile: CACAA2MongoDBDataRetrieverZip, //Var: CACAA2MongoDBDataRetrieverZip      (The location of the CACAA2MongoDBDataRetriever code for the Lambda function of the same name in the zip file)
    }),
    (err, data) => {
      if (err) {
        console.log(err);
      } else {
        console.log(
          "CACAA2MongoDBDataRetriever Lambda code has been successfully uploaded."
        );
      }
    }
  );
}


function invokeDataRefresher() {
  console.log("Refreshing covid data in the MongoDB...");
  LAMBDA.invoke(
    params = {
        FunctionName: "CACAA2MongoDBDataRefresher",
    },
    (err, data) => {
        if(err) {
            console.log(err);
        } else {
            console.log("Data in the MongoDB successfully refreshed");
        }
    }
);
}