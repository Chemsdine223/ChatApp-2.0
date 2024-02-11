const express = require("express");
const http = require("http");
const cors = require("cors");
const setupSocket = require("./middleware/io"); // Change the path accordingly
const redis = require("./Controllers/redisController");


const app = express();
require("dotenv").config();

app.use(cors());
app.use(express.json());
const server = http.createServer(app);

app.use("/api/", require("./router/routes"));

const PORT = process.env.PORT || 5000;

app.use("*", (req, res) => {
  return res.status(404).json({
    message: "Endpoint not found",
  });
});





// console.log(hello);

const io = setupSocket(server);

server.listen(PORT, () => console.log(`Server Connected to port ${PORT}`));

// Handling Error
process.on("unhandledRejection", (err) => {
  console.log(`An error occurred: ${err.message}`);
  server.close(() => process.exit(1));
});

const connectDB = require("./db");
connectDB();

// const express = require('express');
// const path = require('path');
// const axios = require('axios');

// check my server code for me
