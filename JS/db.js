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
    await monitorCollection(client, io, 15000);
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
  const collection = client.db("node_db").collection("chatrooms");
  const changeStream = collection.watch(pipeline, {
    fullDocument: "updateLookup",
  });

  changeStream.on("change", (next) => {
    const conversation = next.documentKey._id;
    console.log({next});


    if (next.operationType === "update") {
      const updatedFields = next.updateDescription.updatedFields;

      for (const key in updatedFields) {
        if (Object.hasOwnProperty.call(updatedFields, key)) {
          const match = key.match(/(\d+)/);

          if (match) {
            const index = parseInt(match[0]);
            const receiver = next.fullDocument.messages[index].receiver;

            console.log(index);

            io.to(String(receiver._id)).emit("seen", {
              message: index,
              conversation: conversation,
            });

            console.log("Sent seen event for index:", index);
          } else {
            console.log("No index found in the key:", key);
          }
        }
      }
    }
  });
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
