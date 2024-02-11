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
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Message", messageSchema);
