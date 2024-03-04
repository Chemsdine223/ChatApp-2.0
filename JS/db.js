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

    if (next.operationType === "update") {
      const updatedFields = next.updateDescription.updatedFields;
      console.log({ updatedFields });
        for (const key in updatedFields) {
          if (Object.hasOwnProperty.call(updatedFields, key)) {
            // Split the key to access individual properties
            const keys = key.split(".");

            console.log({ keys });

            // Check if the key includes 'messages' and 'isSeen'
            if (keys.includes("messages") && keys.includes("isSeen")) {
              console.log("Here we are");
              // Get the index from the key
              const index = parseInt(keys[keys.indexOf("messages") + 1]);

              // Access the isSeen value
              const isSeen = updatedFields[key];

              // Access the relevant information from next.fullDocument
              const message = next.fullDocument.messages[index];
              const receiver = message.receiver;

              io.to(String(receiver._id)).emit("seen", {
                message: index,
                isSeen: true,
                conversation: conversation,
              });

              console.log("Sent seen event to:", receiver._id);
            }
          }
        }
      // }
    }
  });
}

// function closeChangeStream(timeInMs = 60000, changeStream) {
//   return new Promise((resolve) => {
//     setTimeout(() => {
//       console.log("Closing the change stream");
//       changeStream.close();
//       resolve();
//     }, timeInMs);
//   });
// }

module.exports = connectDB;
