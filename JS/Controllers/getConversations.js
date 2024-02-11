const ChatRoom = require("../Models/ChatRoom");
// const redis = require('redis');
const redis = require("./redisController") 
exports.getConversations = async (req, res, next) => {
  try {


    // await redis.set("mykey", "Hello from node redis");
    // const myKeyValue = await redis.get("mykey");
    // console.log(myKeyValue);
    // const rd = await redisClient.get("key", (err, data) => {
    //   if (err) {
    //     console.error(err);
    //   } else {
    //     console.log(data);
    //   }
    // });

    const userId = req.user.id;

    console.log("Request id", req.user.id);

    // Convert the user ID to a string
    const userIdString = userId.toString();

    // Retrieve conversations associated with the given userId
    // const conversations = await ChatRoom.find({
    //   "users._id": userIdString,
    // });

    existingConversations = await redis.get(userIdString);
    // console.log(existingConversations);
    
    // console.log(if);
    // if (existingConversations) {
    //   // console.log("sations from my cache");
    //   const convos = JSON.parse(existingConversations);

    //   res.status(200).json(convos);
    //   return;

      
    // }

    const conversations = await ChatRoom.find({
      users: { $elemMatch: { _id: userIdString } },
    });

    if (conversations.length > 0) {
      await redis.set(userIdString, JSON.stringify(conversations));
      res.status(200).json({
        conversations: conversations,
      });
    } else if (conversations.length == 0) {
      res.status(200).json({
        conversations: [],
      });
    }
  } catch (error) {
    res.status(500).json({
      error: error.message,
    });
  }
};
