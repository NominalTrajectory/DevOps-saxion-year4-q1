const { execSync } = require("child_process");
const fs = require("fs");
const AWS = require("aws-sdk");
const s3 = new AWS.S3();
const lambda = new AWS.Lambda();
const MongoClient = require('mongodb').MongoClient;
const MONGODB_URI = process.env.MONGODB_URI;

let cachedDb = null;

function connectToDatabase (uri) {
  console.log('=> connect to database');

  if (cachedDb) {
    console.log('=> using cached database instance');
    return Promise.resolve(cachedDb);
  }

  return MongoClient.connect(uri)
    .then(client => {
      cachedDb = client.db('covid');
      return cachedDb;
    });
}

exports.handler = (event, context) => {
execSync("rm -rf /tmp/*", { encoding: "utf8", stdio: "inherit" });
execSync(`cd /tmp && git clone https://github.com/broadinstitute/covid19-testing`, {
  encoding: "utf8",
  stdio: "inherit",
});

let f = fs.readFileSync('/tmp/covid19-testing/index.html').toString();
let dataJSON = JSON.parse(f.substring(f.indexOf('[{"d'), f.indexOf('"}]')+3));
connectToDatabase(MONGODB_URI).then(db => {
    db.collection('covid').remove({}).then(success => {
        db.collection('covid').insertMany(dataJSON).then(success => {
            console.log("SUCCESS");
            return;
        });
    });
});

     
};

