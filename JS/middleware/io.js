const socketIO = require("socket.io");
const jwt = require("jsonwebtoken");
const Message = require("../Models/Message");
const ChatRoom = require("../Models/ChatRoom");
const User = require("../Models/user"); // Assuming your user model is defined in User.js
const Keys = require("../Models/Keys");

const activeUsers = new Set();

// const userSocketMap = {};

function setupSocket(server) {
  const io = socketIO(server);

  io.use((socket, next) => {
    const apiKey = socket.handshake.headers.key;
    const userId = socket.handshake.headers.id;

    if (!apiKey) {
      return next(new Error("Authentication failed. No key provided."));
    }

    // Verify the API key and associate the socket with the user
    Keys.findOne({ key: apiKey })
      .populate("user", "_id")
      .then((apiKeyInfo) => {
        if (!apiKeyInfo || String(apiKeyInfo.user._id) !== userId) {
          return next(new Error("Authentication failed. User ID mismatch."));
        }

        // Associate socket with user ID
        socket.id = userId;
        activeUsers.add(userId);
        next();
      })
      .catch((error) => {
        return next(new Error("Authentication failed. Invalid API key."));
      });
  });

  io.on("connection", (socket) => {
    console.log(activeUsers);
    console.log("a user connected: ", socket.id);

    io.emit("connected", {
      message: `Connected as ${socket.id}`,
      users: Array.from(activeUsers),
    });

    // io.emit("onlineUsers", {
    //   users: activeUsers
    // })

    socket.on("disconnect", () => {
      console.log(socket.id, "disconnected");
      activeUsers.delete(socket.id);

      socket.broadcast.emit({
        message: `Connected as ${socket.id}`,
        users: Array.from(activeUsers),
      });
      console.log("emitted");
    });

    socket.on("isOnline", (data) => {
      try {
        const parsed = JSON.parse(data);
        const userId = parsed.id;
    
        const isOnline = activeUsers.has(userId);
    
        io.to(socket.id).emit("isOnline", {
          status: isOnline,
        });
      } catch (error) {
        console.error("Error in isOnline event handler:", error);
        io.to(socket.id).emit("isOnline", {
          status: false,
        });
      }
    });
    socket.on("message", async (data) => {
      data = JSON.parse(data);

      //   console.log(data.rece);

      // let receiverData

      const receiverData = await User.findOne({
        username: data.receiver.username,
      }).select("-password");

      const senderData = await User.findOne({
        username: data.sender.username,
      }).select("-password");

      console.log({ receiverData });

      try {
        if (!receiverData) {
          io.to(socket.id).emit("Error", {
            error: "Receiver not found",
          });
          return;
        } else if (!senderData) {
          io.to(socket.id).emit("Error", {
            error: "Sender not found",
          });
          return;
        }

        let chatRoom = await ChatRoom.findById(data.conversationId);

        // console.log({receiverData});
        // console.log({senderData});

        if (!chatRoom) {
          chatRoom = await ChatRoom.create({
            // users: [data.sender._id, receiverData.id], // Use receiverData._id here
            users: [senderData, receiverData], // Use receiverData._id here

            messages: [],
          });
        }

        // Create a new message
        const message = new Message({
          content: data.content,
          sender: senderData,
          room: chatRoom._id,
          receiver: receiverData,
        });

        socket.to(socket.id);

        chatRoom.messages.push(message);
        await chatRoom.save();

        io.to(data.receiver.id).emit("message", {
          conversationId: chatRoom._id,
          message,
        });

        // Emit the message to the receiver's room
        io.to(receiverData.id).emit("message", {
          conversationId: chatRoom._id,
          message,
        });

        // io.emit("message", {
        //     conversationId: chatRoom._id,
        //     message,
        //   });

        // callback({
        //     status: message
        //   });

        // Broadcast the message to all users in the conversation
        io.to(data.conversationId).emit("message", {
          conversationId: chatRoom._id,
          message,
        });

        io.to(socket.id).emit("message", {
          conversationId: chatRoom._id,
          message,
        });

        console.log("Message saved:", message);
      } catch (error) {
        console.error("Error saving message:", error.message);
      }
    });
  });

  return io;
}

module.exports = setupSocket;
