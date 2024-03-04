const ChatRoom = require("../Models/ChatRoom");
const connectDB = require("../db");

exports.seenStatus = async (req, res, next) => {
  try {
    const { conversationId, messageIndexes } = req.body;

    if (!conversationId || !messageIndexes || !Array.isArray(messageIndexes)) {
      return res.status(400).json({
        message: "Invalid or missing 'conversationId' or 'messageIndexes' array in the request body",
      });
    }

    const chatRoom = await ChatRoom.findById(conversationId);

    if (!chatRoom) {
      return res.status(404).json({
        message: "Chat room not found",
      });
    }

    const updateData = {};

    for (const messageIndex of messageIndexes) {
      if (messageIndex !== undefined && messageIndex >= 0 && messageIndex < chatRoom.messages.length) {
        // Update the isSeen property using the unique conversationId and messageIndex
        const key = `messages.${messageIndex}.isSeen`;
        updateData[key] = true;
      }
    }

    if (Object.keys(updateData).length === 0) {
      return res.status(400).json({
        message: "Invalid or missing valid 'messageIndexes' in the request body",
      });
    }

    // Use the conversationId to identify the document to update
    const filter = { _id: conversationId };

    const updateResult = await ChatRoom.updateOne(filter, { $set: updateData });

    return res.status(200).json({
      message: "Updated status",
      updateResult: updateResult,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: "Update failure",
    });
  }
};
