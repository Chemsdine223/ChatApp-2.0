

exports.editPhoto = async (req, res, next) => {
    const userId = req.user.id;
  
    const phoneNumber = req.body.url;
  
    try {
      const filter = { _id: userId };
      const update = { phone: phoneNumber };
      const result = await user.findOneAndUpdate(filter, update, {
        new: true,
      });
  
      console.log({result});
  
      if (result) {
      //   res.status(200).json({ message: "Phone updated successfully" });
        res.status(200).json({ user: result });
      }
      if (!result) {
        res.status(400).json({ message: ""});
      }
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  };