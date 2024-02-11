const Blog = require("../Models/Blog");

exports.getBlogs = async (req, res, next) => {
  try {
    // Assuming user ID is stored in req.user.id from your middleware
    const userId = req.user.id;

    // Retrieve blogs associated with the given userId
    const userBlogs = await Blog.find({ user: userId }).select("-user -__v");

    res.status(200).json({
      blogs: userBlogs,
    });
  } catch (error) {
    res.status(400).json({
      error: error.message,
    });
  }
};
