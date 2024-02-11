const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const keySchema = mongoose.Schema(
  {
    key: {
      type: String,
    },
    user: {
      type: Schema.Types.ObjectId,
      ref: "User",
    },
  },
  {
    timestamps: true,
  }
);


module.exports = mongoose.model("Key", keySchema)

