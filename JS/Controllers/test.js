const ChatRoom = require("../Models/ChatRoom");
const user = require("../Models/user");
const connectDB = require("../db");

exports.testEp = async () => {
  const updateData = {
    $set: {
      "messages.$[].content": "someValue", // Update all messages' content
    },
  };

  try {
    const update = await ChatRoom.updateMany({}, updateData);
    console.log({update});



    // let conn = await connectDB();

    // await user.create({
    //   username: "Username",
    //   phone: "332",
    //   firstname: "fn",
    //   lastname: "ln",
    //   avatar: "a",
    //   deviceToken: "cccc",
    // });
  } catch (error) {
    console.log(error);
  }
};
