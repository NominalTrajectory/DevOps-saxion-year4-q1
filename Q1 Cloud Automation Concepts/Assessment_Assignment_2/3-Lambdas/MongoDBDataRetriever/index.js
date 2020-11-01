const MongoClient = require("mongodb").MongoClient;
const MONGODB_URI = process.env.MONGODB_URI;

let cachedDb = null;

function connectToDatabase(uri) {
  console.log("=> connect to database");

  if (cachedDb) {
    console.log("=> using cached database instance");
    return Promise.resolve(cachedDb);
  }

  return MongoClient.connect(uri)
    .then((client) => {
      cachedDb = client.db("covid");
      return cachedDb;
    })
    .catch((err) => {
      console.log(err);
      return err;
    });
}

exports.handler = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;

  connectToDatabase(MONGODB_URI)
    .then((db) => {
      db.collection("covid")
        .find({})
        .toArray()
        .then((data) => {
          callback(null, { statusCode: 200, body: JSON.stringify(data), headers: {'Content-Type': 'application/json', "Access-Control-Allow-Headers" : "Content-Type",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET"}});
        });
    })
    .catch((err) => {
      callback(err);
    });
};
