const Mongoose = require("mongoose")
const localDB = `mongodb://localhost:27017/node_db`
const connectDB = async () => {
  await Mongoose.connect(localDB, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  console.log("MongoDB Connected")
}
module.exports = connectDB

// 65d0a363ebe2262fce94b23e