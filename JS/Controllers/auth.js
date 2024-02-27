const User = require("../Models/user");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
require("dotenv").config();
const jwtSecret = process.env.JWT_SECRET_KEY;
const { io } = require("../middleware/io");
const Keys = require("../Models/Keys");
const crypto = require("crypto");

exports.register = async (req, res, next) => {
  console.log(req.body);
  const { username, phone, firstname, lastname, avatar, token } = req.body;
  const apiKey = crypto.randomBytes(16).toString("hex");
  // console.log({ apiKey });

  // console.log({avatar});

  try {
    const user = await User.create({
      username,
      phone,
      firstname,
      lastname,
      avatar,
      deviceToken:token
    });

    if (user) {
      // console.log(apiKey);

      await Keys.create({
        user: user,
        key: apiKey,
        message: "Created successfully",
      });
    }

    res.status(200).json({
      user: user,
      key: apiKey,
    });
  } catch (error) {
    if (error.code === 11000) {
      if (error.keyPattern.phone) {
        res.status(404).json({
          message: "Phone number already exists",
          error: error,
        });
      } else if (error.keyPattern.username) {
        res.status(404).json({
          message: "Username already taken",
          error: error,
        });
      }
    } else {
      res.status(500).json({
        message: error.message,
      });
    }
  }
};

exports.login = async (req, res, next) => {
  const { username, password } = req.body;
  try {
    const user = await User.findOne({ username });

    if (!user) {
      res.status(404).json({ message: "User not found" });
    } else {
      bcrypt.compare(password, user.password).then(function (result) {
        // console.log(result);
        if (result) {
          const token = jwt.sign(
            {
              user: {
                id: user._id,
                username,
                firstname: user.firstname,
                lastname: user.lastname,
              },
            },
            process.env.JWT_SECRET_KEY,
            {
              expiresIn: "1h",
            }
          );

          res.status(200).json({
            message: "User logged in successfully",
            user,
            token,
          });

          // io.emit("user connected", { userId: user.id });
        } else {
          res.status(400).json({ message: "Check your credentials" });
        }
      });
    }
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};
