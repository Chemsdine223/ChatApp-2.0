const Mongoose = require("mongoose");
const { MongoClient, ServerApiVersion } = require("mongodb");
const setupSocket = require("./middleware/io");

const uri =
  "mongodb+srv://nodeuser:GPwIVnmOanoaovw9@cluster0.tbhffgr.mongodb.net/node_db?retryWrites=true&w=majority&appName=Cluster0";
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
});

// const cl = Mongoose.connect(uri ,)
const connectDB = async (io) => {
  try {
    await Mongoose.connect(uri, {
      autoIndex: true,
    });
    await client.connect();
    console.log("connected !");
    // await
    await monitorCollection(client,io, 15000);
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

async function monitorCollection(client, io, timeInMS = 60000, pipeline = []) {
  const collection = client.db("node_db").collection("users");
  const changeStream = collection.watch(pipeline);
  changeStream.on("change", (next) => {
    console.log(next);
    io.emit("Updated", {
      "message":"Hello"
    })
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

module.exports = connectDB;
