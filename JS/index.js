const express = require("express");
const http = require("http");
const cors = require("cors");
const setupSocket = require("./middleware/io"); // Change the path accordingly
const redis = require("./Controllers/redisController");
// const x = 
const app = express();
require("dotenv").config();

var admin = require("firebase-admin");






const { initializeApp, applicationDefault } = require("firebase-admin/app");


app.use(express.json());
const server = http.createServer(app);
// http://localhost:5000/

process.env.GOOGLE_APPLICATION_CREDENTIALS

var serviceAccount = require("./pushnotifications-d9a92-firebase-adminsdk-stspy-61edb0b08f.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: "pushnotifications-d9a92", 
});

var whitelist = ["http://localhost:5000"]; //white list consumers
var corsOptions = {
  origin: function (origin, callback) {
    if (whitelist.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(null, false);
    }
  },
  methods: ["GET", "PUT", "POST", "DELETE", "OPTIONS"],
  optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
  credentials: true, //Credentials are cookies, authorization headers or TLS client certificates.
  allowedHeaders: [
    "Content-Type",
    "Authorization",
    "X-Requested-With",
    "device-remember-token",
    "Access-Control-Allow-Origin",
    "Origin",
    "Accept",
  ],
};

app.use(cors(corsOptions));

app.use("/api/", require("./router/routes"));

const PORT = process.env.PORT || 5000;

app.use("*", (req, res) => {
  return res.status(404).json({
    message: "Endpoint not found",
  });
});

var corsOptions = {
  origin: "http://example.com",
  optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
};

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
