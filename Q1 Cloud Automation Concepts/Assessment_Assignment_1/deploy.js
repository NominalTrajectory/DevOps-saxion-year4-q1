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

//Description: Importing of the AWS npm packages
const AWS = require("aws-sdk");
const { CodeDeploy } = require("aws-sdk");





//Description: define the AWS credentails:
const credentials = new AWS.SharedIniFileCredentials({
  profile: "default",
});
AWS.config.credentials = credentials;
AWS.config.update({region: "us-east-1",});
AWS.config.apiVersions = {lambda: "2015-03-31",};




//Description: Instanciating AWS API classes
const CFN = new AWS.CloudFormation();
const LAMBDA = new AWS.Lambda();





//Description: Define the stack locations in the enviroment
const BASE_NETWORK_STACK_TEMPLATE = fs.readFileSync("./1-BaseStack/aa1_base_network.yml");
const EFS_STACK_TEMPLATE = fs.readFileSync("./2-EFSStack/cac_aa1_efs.yml");
const DATA_LAYER_STACK_TEMPLATE = fs.readFileSync("./3-DataLayerStack/aa1_data_layer_stack.yml");
const AUTOSCALING_WEB_STACK_TEMPLATE = fs.readFileSync("./5-AutoscalingWebStack/aa1_autoscaling_loadbalanced_covid_dashboard.yml");
const S3_STACK_TEMPLATE = fs.readFileSync("./7-S3Stack/aa1_s3_nhs.yml");





//Description: Define the script location for the code/configuartion of the Lambda functions
const CACAA1MongoDBDataRefresherZip = fs.readFileSync("./4-Lambdas/MongoDBDataRefresher/MongoDBDataRefresher.zip");
const CACAA1MongoDBDataRetrieverZip = fs.readFileSync("./4-Lambdas/MongoDBDataRetriever/MongoDBDataRetriever.zip");





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
      TemplateBody: `${BASE_NETWORK_STACK_TEMPLATE}`,                         //Var: BASE_NETWORK_STACK_TEMPLATE          (The location of the BaseStack yml file)
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
              deployEFSStack();                                                 //Fun: deployEFSStack                     (The function that deploys the EFSStack)
              deployS3Stack();                                                  //Fun: deployS3Stack                      (The function that deploys the S3Stack)
              deployDataLayerStack();                                           //Fun: deployDataLayerStack               (The function that deploys the DataLayerStack)
            }
          }
        );
      }
    }
  );
}

/*Descrition: This is the deployEFSStack function, it is called by the deploy function of the program and starts the deployment of the EFSStack and runs parales with the functions that 
              build the DataLayerStack and the S3Stack, ending with a message to the console alerting the user the deployment is complete or has failed */
function deployEFSStack() {
  console.log(
    `Deploying the EFSStack for storing the webserver logs. Please wait (~2 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "EFSStack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${EFS_STACK_TEMPLATE}`,                                    //Var: EFS_STACK_TEMPLATE                 (The location of the EFSStack yml file)
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
            StackName: "EFSStack",
          }),
          (err, data) => {
            if (err) {
              console.warn(err);
              process.exit(1);
            } else {
              console.log(`EFSStack has been successfully deployed.`);
              return true;
            }
          }
        );
      }
    }
  );
}

/*Descrition: This is the deployS3Stack function, it is called by the deploy function of the program and starts the deployment of the S3Stack and runs parales with the functions that 
              build the DataLayerStack and the S3Stack, ending with a message to the console alerting the user the deployment is complete or has failed */
function deployS3Stack() {
  console.log(
    `Deploying the S3Stack with the COVID-19 game static website. Please wait (~2 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "S3Stack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${S3_STACK_TEMPLATE}`,                                     //Var: S3_STACK_TEMPLATE                  (The location of the WebStack yml file)
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
        //Wait for S3Stack deployment to complete
        CFN.waitFor(
          "stackCreateComplete",
          (params = {
            StackName: "S3Stack",
          }),
          (err, data) => {
            if (err) {
              console.warn(err);
              process.exit(1);
            } else {
              console.log(`S3Stack has been successfully deployed.`);
              return true;
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
      TemplateBody: `${DATA_LAYER_STACK_TEMPLATE}`,                             //Var: DATA_LAYER_STACK_TEMPLATE          (The location of the DataLayerStack yml file)
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
              uploadCACAA1MongoDBDataRefresherCode();                           //Fun: uploadCACAA1MongoDBDataRefresherCode   (The function that uploads the code for the CACAA1MongoDBDataRefresher Lambda function)
              uploadCACAA1MongoDBDataRetrieverCode();                           //Fun: uploadCACAA1MongoDBDataRetrieverCode   (The function that uploads the code for the CACAA1MongoDBDataRetriever Lambda function)
              deployWebStack();                                                 //Fun: deployWebStack                     (The function that deploys the WebStack)
            }
          }
        );
      }
    }
  );
}

/*Descrition: This is the deployWebStack function, it is called by the deployDataLayerStack function of the program and starts the deployment of the WebStack, ending with a message 
              to the console alerting the user the deployment is complete or has failed */
function deployWebStack() {
  console.log(
    `Deploying the WebStack with autoscaling, loadbalanced COVID dashboard. Please wait (~4 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "WebStack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${AUTOSCALING_WEB_STACK_TEMPLATE}`,                        //Var: AUTOSCALING_WEB_STACK_TEMPLATE     (The location of the WebStack yml file)
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
        CFN.waitFor(
          //Wait for WebStack deployment to complete
          "stackCreateComplete",
          (params = {
            StackName: "WebStack",
          }),
          (err, data) => {
            if (err) {
              console.warn(err);
              process.exit(1);
            } else {
              console.log(`WebStack has been successfully deployed.`);
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


/*Descrition: This is the uploadCACAA1MongoDBDataRefresherCode function, it is called by the deployDataLayerStack function of the program and uplaods the code for the CACAA1MongoDBDataRefresher 
              Lambda function of the WebStack, ending with a message to the console alerting the user the upload is complete or has failed */
function uploadCACAA1MongoDBDataRefresherCode() {
  LAMBDA.updateFunctionCode(
    (params = {
      FunctionName: "CACAA1MongoDBDataRefresher",
      ZipFile: CACAA1MongoDBDataRefresherZip,                                   //Var: CACAA1MongoDBDataRefresherZip      (The location of the CACAA1MongoDBDataRefresher code for the Lambda function of the same name in the zip file)
    }),
    (err, data) => {
      if (err) {
        console.log(err);
      } else {
        console.log(
          "CACAA1MongoDBDataRefresher Lambda code has been successfully uploaded."
        );
      }
    }
  );
}

/*Descrition: This is the uploadCACAA1MongoDBDataRetrieverCode function, it is called by the deployDataLayerStack function of the program and uplaods the code for the CACAA1MongoDBDataRetriever 
              Lambda function of the WebStack, ending with a message to the console alerting the user the upload is complete or has failed */
function uploadCACAA1MongoDBDataRetrieverCode() {
  LAMBDA.updateFunctionCode(
    (params = {
      FunctionName: "CACAA1MongoDBDataRetriever",
      ZipFile: CACAA1MongoDBDataRetrieverZip,                                   //Var: CACAA1MongoDBDataRetrieverZip      (The location of the CACAA1MongoDBDataRetriever code for the Lambda function of the same name in the zip file)
    }),
    (err, data) => {
      if (err) {
        console.log(err);
      } else {
        console.log(
          "CACAA1MongoDBDataRetriever Lambda code has been successfully uploaded."
        );
      }
    }
  );
}
