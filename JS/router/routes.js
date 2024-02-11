const express = require("express");
const { register, login } = require("../Controllers/auth");
const verifyToken = require("../middleware/middleware");
const { getBlogs } = require("../Controllers/getusers");
const { createBlog } = require("../Controllers/createBlog");
const { getConversations } = require("../Controllers/getConversations");
const { createConversation } = require("../Controllers/createConversation");
const router = express.Router();

router.route("/register").post(register);
router.route("/login").post(login);

router.route("/getblogs").get(verifyToken, getBlogs);
router.route("/createblog").post(verifyToken, createBlog);
router.route("/getConvos").get(verifyToken, getConversations);

router.route("/createConversation").post(verifyToken, createConversation)


module.exports = router;
