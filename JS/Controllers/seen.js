const ChatRoom = require("../Models/ChatRoom");
const connectDB = require("../db");

exports.seenStatus = async (req, res, next) => {
  try {
    const { conversationId, messageIds } = req.body;

    if (!conversationId || !messageIds || !Array.isArray(messageIds)) {
      return res.status(400).json({
        message: "Invalid or missing 'conversationId' or 'messageIds' array in the request body",
      });
    }

    const updatePromises = messageIds.map(async (messageId) => {
      if (messageId) {
        const updateResult = await ChatRoom.updateMany(
          { _id: conversationId, "messages._id": messageId },
          { $set: { "messages.$.isSeen": true } }
        );

        return updateResult;
      }
    });

    const updateResults = await Promise.all(updatePromises);

    return res.status(200).json({
      message: "Updated status",
      updateResults: updateResults,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: "Update failure",
    });
  }
};
