const ChatRoom = require("../Models/ChatRoom");

exports.deleteConversation = async (req, res, next) => {
  const { conversationId, userId } = req.body;
  console.log(req.body);

  const filter = { _id: conversationId };
  const update = { deletedFor: [userId] };

  try {
    
    let doc = await ChatRoom.findOneAndUpdate(filter, update);

    if (doc) {
      res.status(200).json({
        message: "deleted successfully",
      });
    } else {
      res.status(404).json({ message: "Couldn't delete the conversation" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "An error occured" });
  }
};
