const Mongoose = require("mongoose");
// const localDB = `mongodb://localhost:27017/node_db`
// const localDB = `mongodb+srv://chemsdine223:<PdpU9RoFsTMRIZGc>@cluster0.tbhffgr.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0`
// const connectDB = async () => {
//   await Mongoose.connect(localDB, {
//     useNewUrlParser: true,
//     useUnifiedTopology: true,
//   })
//   console.log("MongoDB Connected")

// }

const { MongoClient, ServerApiVersion } = require("mongodb");
const uri =
  "mongodb+srv://nodeuser:GPwIVnmOanoaovw9@cluster0.tbhffgr.mongodb.net/node_db?retryWrites=true&w=majority&appName=Cluster0";
// Create a MongoClient with a MongoClientOptions object to set the Stable API version
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
});
const connectDB = async () => {
  try {
    await client.connect();
    console.log("connected !");
    // await 
    await monitorCollection(client, 15000);
  } catch (error) {
    console.log({ error });
  }
  // try {
  //   await Mongoose.connect(uri, {
  //     autoIndex: true,
  //   });
  //   console.log("Connected to Mongodb Atlas");
  // } catch (error) {
  //   console.error(error);
  // }
};

async function monitorCollection(client, timeInMS = 60000, pipeline = []) {
  const collection =  client.db("node_db").collection("users");
  const changeStream = collection.watch(pipeline);
  changeStream.on("change", (next) => {
    console.log(next);
  });

  // await closeChangeStream(timeInMS, changeStream);
}

function closeChangeStream(timeInMs = 60000, changeStream) {
  return new Promise((resolve) => {
    setTimeout(() => {
      console.log("Closing the change stream");
      changeStream.close();
      resolve();
    }, timeInMs);
  });
}

// run()
module.exports = connectDB;

// 65d0a363ebe2262fce94b23e

// sgbzt8S5YYMNJvZU
