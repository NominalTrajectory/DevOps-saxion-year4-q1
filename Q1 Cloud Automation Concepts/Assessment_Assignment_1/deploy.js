const { performance } = require("perf_hooks");
const { CodeDeploy } = require("aws-sdk");
const AWS = require("aws-sdk");
const { error } = require("console");
const fs = require("fs");
const { exit } = require("process");
const credentials = new AWS.SharedIniFileCredentials({
  profile: "default",
});
AWS.config.credentials = credentials;
AWS.config.update({
  region: "us-east-1",
});
AWS.config.apiVersions = {
  lambda: "2015-03-31",
};
const CFN = new AWS.CloudFormation();
const LAMBDA = new AWS.Lambda();

const BASE_NETWORK_STACK_TEMPLATE = fs.readFileSync(
  "./1-BaseStack/aa1_base_network.yml"
);
const EFS_STACK_TEMPLATE = fs.readFileSync("./2-EFSStack/cac_aa1_efs.yml");
const DATA_LAYER_STACK_TEMPLATE = fs.readFileSync(
  "./3-DataLayerStack/aa1_data_layer_stack.yml"
);
const AUTOSCALING_WEB_STACK_TEMPLATE = fs.readFileSync(
  "./5-AutoscalingWebStack/aa1_autoscaling_loadbalanced_covid_dashboard.yml"
);
const S3_STACK_TEMPLATE = fs.readFileSync("./7-S3Stack/aa1_s3_nhs.yml");

const CACAA1MongoDBDataRefresherZip = fs.readFileSync(
  "./4-Lambdas/MongoDBDataRefresher/MongoDBDataRefresher.zip"
);
const CACAA1MongoDBDataRetrieverZip = fs.readFileSync(
  "./4-Lambdas/MongoDBDataRetriever/MongoDBDataRetriever.zip"
);

let t0 = performance.now();

deploy();

function deploy() {
  console.log(
    `Deploying the BaseStack with network configuration. Please wait (~5 min)...`
  );
  return CFN.createStack(
    (params = {
      StackName: "BaseStack",
      TemplateBody: `${BASE_NETWORK_STACK_TEMPLATE}`,
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
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
              deployEFSStack();
              deployDataLayerStack();
              deployS3Stack();
            }
          }
        );
      }
    }
  );
}

function deployEFSStack() {
  console.log(
    `Deploying the EFSStack for storing the webserver logs. Please wait (~2 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "EFSStack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${EFS_STACK_TEMPLATE}`,
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
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

function deployDataLayerStack() {
  console.log(
    `Deploying the DataLayerStack with MongoDB, REST API and underlying Lambda functions. Please wait (~5 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "DataLayerStack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${DATA_LAYER_STACK_TEMPLATE}`,
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
        CFN.waitFor(
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
              uploadCACAA1MongoDBDataRefresherCode();
              uploadCACAA1MongoDBDataRetrieverCode();
              deployWebStack();
            }
          }
        );
      }
    }
  );
}

function deployWebStack() {
  console.log(
    `Deploying the WebStack with autoscaling, loadbalanced COVID dashboard. Please wait (~4 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "WebStack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${AUTOSCALING_WEB_STACK_TEMPLATE}`,
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
        CFN.waitFor(
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

function deployS3Stack() {
  console.log(
    `Deploying the S3Stack with the COVID-19 game static website. Please wait (~2 min)...`
  );
  CFN.createStack(
    (params = {
      StackName: "S3Stack",
      Capabilities: ["CAPABILITY_NAMED_IAM"],
      TemplateBody: `${S3_STACK_TEMPLATE}`,
    }),
    (err, data) => {
      if (err) {
        console.warn(err);
        process.exit(1);
      } else {
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

function uploadCACAA1MongoDBDataRefresherCode() {
  LAMBDA.updateFunctionCode(
    (params = {
      FunctionName: "CACAA1MongoDBDataRefresher",
      ZipFile: CACAA1MongoDBDataRefresherZip,
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

function uploadCACAA1MongoDBDataRetrieverCode() {
  LAMBDA.updateFunctionCode(
    (params = {
      FunctionName: "CACAA1MongoDBDataRetriever",
      ZipFile: CACAA1MongoDBDataRetrieverZip,
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
