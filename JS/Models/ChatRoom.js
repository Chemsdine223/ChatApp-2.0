const mongoose = require("mongoose");
const Message = require("../Models/Message");
const User = require("../Models/user");

const chatRoomSchema = mongoose.Schema({
  messages: [Message.schema],
  users: Array,
});

module.exports = mongoose.model("ChatRoom", chatRoomSchema);
