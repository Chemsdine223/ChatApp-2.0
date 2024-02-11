const Blog = require("../Models/Blog");

exports.createBlog = async (req, res, next) => {
  const { title, content } = req.body;
  const user = req.user;

  try {
    const blog = await Blog.create({
      title,
      content,
      user: user.id,
      author: user.username
    });
    res
      .status(201)
      .json({ message: "Blog created successfully", blog: blog.title });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};


