const ChatRoom = require("../Models/ChatRoom");
const user = require("../Models/user");
const connectDB = require("../db");

exports.seenStatus = async (req, res, next) => {
  const updateData = {
    $set: {
      "messages.$[element].isSeen": true,
    },
  };

  const options = {
    arrayFilters: [{ "element.isSeen": { $ne: true } }],
  };

  try {
    const update = await ChatRoom.updateMany({}, updateData, options);
    console.log({ update });

    return res.status(200).json({
      message: "Updated status",
    });
  } catch (error) {
    console.log(error);
    return res.status(200).json({
      message: "Update failure",
    });
  }
};
