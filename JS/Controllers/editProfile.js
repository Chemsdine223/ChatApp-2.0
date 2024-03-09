const user = require("../Models/user");

exports.editPhoto = async (req, res, next) => {

  console.log(req);
  const userId = req.user.id;
  

  console.log({req});
  console.log({userId});
  const photoUrl = req.body.url;

  try {
    const filter = { _id: userId };
    const update = { avatar: photoUrl };
    const result = await user.findOneAndUpdate(filter, update, {
      new: true,
    });

    console.log({ result });

    if (result) {
      //   res.status(200).json({ message: "Phone updated successfully" });
      res.status(200).json({ user: result });
    }
    if (!result) {
      res.status(400).json({ message: "" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
