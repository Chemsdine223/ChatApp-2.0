const Keys = require("../Models/Keys");


const verifyToken = async (req, res, next) => {
  try {
    let key;
    let authHeader = req.headers.authorization || req.headers.Authorization;

    if (authHeader && authHeader.startsWith("Api-Key")) {
      key = authHeader.split(" ")[1];

      if (key) {
        // Assuming Keys model has a 'user' field referencing the user associated with the key
        const apiKeyInfo = await Keys.findOne({ key }).populate("user", "_id");

        if (apiKeyInfo) {
          req.apiKey = key;
          req.user = apiKeyInfo.user;
          next();
        } else {
          res.status(401).json({
            message: "Invalid API Key",
          });
        }
      } else {
        res.status(401).json({
          message: "API Key is missing",
        });
      }
    } else {
      res.status(401).json({
        message: "Invalid authorization header",
      });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
};

module.exports = verifyToken;

// Li fangue ke indil -> 4e mn mnyn jaybou
// Li fangue kan mo ko indil -> 4e mn jaybou
