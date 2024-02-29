const user = require("../Models/user");
const connectDB = require("../db");

exports.testEp = async () => {

  try {

    // let conn = await connectDB();

    await user.create({
      username: "A username",
      phone: "33221122",
      firstname: "fn",
      lastname: "ln",
      avatar: "a",
      deviceToken: "dT",
    });
    
  } catch (error) {
    console.log(error);
  }
};
