const { getMessaging } = require("firebase-admin/messaging");

exports.sendMessageNotification = (title, body, token) => {
  const message = {
    data: {
      conversationId: "65df33e819cb8b390cd10c5a",
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
      title: "Hello",
      body: "Come on now.",
    },
    token:
      "eNq8JAZRRvys3Uj9bDuIpR:APA91bHqn18HR6_Ga3Jf0Qay-rhgFEcqtziYRY02GV9GSsQQjfNit78SoTEP9IhIcdaRjajXM52znYECn1RLFWqTgSk3GYS_itXRR_wLDkMJ5UhFQXgN3hg6Ga0nZg9B_jbshzy0-tVJ",
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
