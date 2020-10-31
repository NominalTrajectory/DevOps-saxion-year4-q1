//ELKStack, WebStack, DataStack+S3Stack+EFSStack, BaseStack, S3 files, S3Stack

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
const S3 = new AWS.S3();

destroy();

function destroy() {
  console.log("Destroying the ELKStack. This may take up to 5 minutes...");
  CFN.describeStacks((params = { StackName: "ELKStack" }), (err, data) => {
    if (err && err.code == "ValidationError") {
      //ELKStack doesn't exist, moving on to the next stack.
      console.log("ELKStack doesn't exist. Moving on..");
      destroyWebStack();
    } else {
      CFN.deleteStack(
        (params = {
          StackName: "ELKStack",
        }),
        (err, data) => {
          if (err) {
            console.log(err);
          } else {
            CFN.waitFor(
              "stackDeleteComplete",
              (params = {
                StackName: "ELKStack",
              }),
              (err, data) => {
                if (err) {
                } else {
                  console.log("ELKStack has been successfully destroyed");
                  destroyWebStack();
                }
              }
            );
          }
        }
      );
    }
  });
}

function destroyWebStack() {
  console.log("Destroying the WebStack. This may take up to 5 minutes...");
  CFN.describeStacks((params = { StackName: "WebStack" }), (err, data) => {
    if (err && err.code == "ValidationError") {
      //WebStack doesn't exist, moving on to the next stack.
      console.log("WebStack doesn't exist. Moving on..");
      destroyDataLayerStack();
    } else {
      CFN.deleteStack(
        (params = {
          StackName: "WebStack",
        }),
        (err, data) => {
          if (err) {
            console.log(err);
          } else {
            CFN.waitFor(
              "stackDeleteComplete",
              (params = {
                StackName: "WebStack",
              }),
              (err, data) => {
                if (err) {
                } else {
                  console.log("WebStack has been successfully destroyed");
                  destroyDataLayerStack();
                }
              }
            );
          }
        }
      );
    }
  });
}

function destroyDataLayerStack() {
  console.log(
    "Destroying the DataLayerStack. This may take up to 10 minutes..."
  );
  CFN.describeStacks(
    (params = { StackName: "DataLayerStack" }),
    (err, data) => {
      if (err && err.code == "ValidationError") {
        //DataLayerStack doesn't exist, moving on to the next stack.
        console.log("DataLayerStack doesn't exist. Moving on..");
        destroyEFSStack();
      } else {
        CFN.deleteStack(
          (params = {
            StackName: "DataLayerStack",
          }),
          (err, data) => {
            if (err) {
              console.log(err);
            } else {
              CFN.waitFor(
                "stackDeleteComplete",
                (params = {
                  StackName: "DataLayerStack",
                }),
                (err, data) => {
                  if (err) {
                  } else {
                    console.log(
                      "DataLayerStack has been successfully destroyed"
                    );
                    destroyEFSStack();
                  }
                }
              );
            }
          }
        );
      }
    }
  );
}

function destroyEFSStack() {
  console.log("Destroying the EFSStack. This may take up to 5 minutes...");
  CFN.describeStacks((params = { StackName: "EFSStack" }), (err, data) => {
    if (err && err.code == "ValidationError") {
      //DataLayerStack doesn't exist, moving on to the next stack.
      console.log("EFSStack doesn't exist. Moving on..");
      destroyBaseStack();
      destroyS3Stack();
    } else {
      CFN.deleteStack(
        (params = {
          StackName: "EFSStack",
        }),
        (err, data) => {
          if (err) {
            console.log(err);
          } else {
            CFN.waitFor(
              "stackDeleteComplete",
              (params = {
                StackName: "EFSStack",
              }),
              (err, data) => {
                if (err) {
                } else {
                  console.log("EFSStack has been successfully destroyed");
                  destroyBaseStack();
                  destroyS3Stack();
                }
              }
            );
          }
        }
      );
    }
  });
}

function destroyBaseStack() {
  console.log("Destroying the BaseStack. This may take up to 10 minutes...");
  CFN.describeStacks((params = { StackName: "BaseStack" }), (err, data) => {
    if (err && err.code == "ValidationError") {
      //BaseStack doesn't exist, moving on to the next stack.
      console.log("BaseStack doesn't exist.");
    } else {
      CFN.deleteStack(
        (params = {
          StackName: "BaseStack",
        }),
        (err, data) => {
          if (err) {
            console.log(err);
          } else {
            CFN.waitFor(
              "stackDeleteComplete",
              (params = {
                StackName: "BaseStack",
              }),
              (err, data) => {
                if (err) {
                } else {
                  console.log("BaseStack has been successfully destroyed");
                  console.log(
                    "CAC AA1 environment has been successfully destroyed. Byeee."
                  );
                }
              }
            );
          }
        }
      );
    }
  });
}

function destroyS3Stack() {
  clearBucket(S3, "cac-aa1-static-website-covid-game");
  sleep(10000).then(() => {
    console.log("Destroying the S3Stack. This may take up to 2 minutes...");
    CFN.describeStacks((params = { StackName: "S3Stack" }), (err, data) => {
      if (err && err.code == "ValidationError") {
        //BaseStack doesn't exist, moving on to the next stack.
        console.log("S3Stack doesn't exist.");
      } else {
        CFN.deleteStack(
          (params = {
            StackName: "S3Stack",
          }),
          (err, data) => {
            if (err) {
              console.log(err);
            } else {
              CFN.waitFor(
                "stackDeleteComplete",
                (params = {
                  StackName: "S3Stack",
                }),
                (err, data) => {
                  if (err) {
                  } else {
                    console.log("S3Stack has been successfully destroyed");
                  }
                }
              );
            }
          }
        );
      }
    });
  });
}

function deleteObject(client, deleteParams) {
  client.deleteObject(deleteParams, function (err, data) {
    if (err) {
      console.log("delete err " + deleteParams.Key);
    } else {
      console.log("deleted " + deleteParams.Key);
    }
  });
}

function deleteBucket(client, bucket) {
  client.deleteBucket({ Bucket: bucket }, function (err, data) {
    if (err) {
      console.log("error deleting bucket " + err);
    } else {
      console.log("delete the bucket " + data);
    }
  });
}

function clearBucket(client, bucket) {
  client.listObjects({ Bucket: bucket }, function (err, data) {
    if (err) {
      console.log("error listing bucket objects " + err);
      return;
    }
    let items = data.Contents;
    for (let i = 0; i < items.length; i += 1) {
      let deleteParams = { Bucket: bucket, Key: items[i].Key };
      deleteObject(client, deleteParams);
    }
  });
}
