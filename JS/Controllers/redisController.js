var redis = require("redis").createClient(6379);

(async () => {
  redis.on("error", (err) => {
    console.log("Redis Client Error", err);
  });
  redis.on("ready", () => console.log("Redis is ready"));

  await redis.connect();

  await redis.ping();
})();
// redis.on("connect", function () {
//   console.log("Redis server online.");
// });
module.exports = redis;
