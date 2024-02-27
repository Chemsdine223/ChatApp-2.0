const { getMessaging } = require("firebase-admin/messaging");

exports.sendMessageNotification = (title, body, token) => {
  const message = {
    data:{
      "conversationId":"65de551338a5020b8e95b255"
    },
    notification: {
      title: title,
      body: body,
    },
    token: token,
  };
  console.log({ token });

  getMessaging()
    .send(message)
    .then((response) => {
      // Response is a message ID string.
      console.log("Successfully sent message:", response);
      // res.status(200).json({
      //   message: "Sent successfully",
      // });
    })
    .catch((error) => {
      // res.status(500).json({ error: error });
      console.log("Error sending message:", error);
    });
};

exports.sendNotification = (req, res, next) => {
  const message = {
    notification: {
      title: "Bro stop killing this sh*t",
      body: "Come on now.",
    },
    token:
      "cbPuzRbDSwSAym8crBzqbP:APA91bHVbL6oXBaSvOwBX0mOmR3pw-ZtJpN48bW-UhtRjfE79ptJRGGiZ3pOqN-2cU4hGbpG_i49ktEuKPpllNiByQMK4ZFxAxabsoAzD5VWGl0pCc0ap6iwPh9AB3Su_3hpslULlIMo",
  };

  getMessaging()
    .send(message)
    .then((response) => {
      // Response is a message ID string.
      console.log("Successfully sent message:", response);
      res.status(200).json({
        message: "Sent successfully",
      });
    })
    .catch((error) => {
      res.status(500).json({ error: error });
      console.log("Error sending message:", error);
    });
};
