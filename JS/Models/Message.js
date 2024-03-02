const mongoose = require("mongoose");

const { Schema } = mongoose;

const messageSchema = mongoose.Schema(
  {
    content: {
      type: String,
    },
    sender: {
      type: Object,
    },
    receiver: {
      type: Object,
    },
    room: {
      type: Schema.Types.ObjectId,
      ref: "ChatRoom",
    },
    isSeen: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Message", messageSchema);
