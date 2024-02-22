const Keys = require("../Models/Keys");
const user = require("../Models/user");

exports.deleteAccount = async (req, res, next) => {
  //   const { title, content } = req.body;
  const userId = req.user.id;

  try {
    const userFound = await user.findOne({
      _id: userId,
    });

    // console.log({userFound});

    if (userFound) {
      const result = await Keys.deleteOne({
        user: userId,
      });
      if (result) {
        await user.deleteOne({
          _id: userId,
        });
      }
    }

    res.status(201).json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
