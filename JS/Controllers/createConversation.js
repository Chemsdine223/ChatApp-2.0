const ChatRoom = require("../Models/ChatRoom");
const User = require("../Models/user");


exports.createConversation = async (req, res, next) => {
  try {
    const user1 = await User.findById(req.user);
    const user2 = await User.findOne({ phone: req.body.phone });

    if (!user2) {
      res.status(404).json({
        message: "User not found",
      });
      return; // Stop further execution if user2 is not found
    }

    // Check if a conversation already exists between user1 and user2
    const existingConversation = await ChatRoom.findOne({
      $and: [
        { "users._id": user1._id },
        { "users._id": user2._id }
      ],
    });

    if (existingConversation) {
      res.status(400).json({
        message: "Conversation already exists",
        conversation: existingConversation,
      });
      return; // Stop further execution if conversation already exists
    }

    // If no existing conversation, create a new one
    const conversation = await ChatRoom.create({
      users: [user1, user2],
      messages: [],
    });

    res.status(201).json({
      message: "Chatroom created successfully",
      conversation: conversation,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
