// import 'package:chat_app/Constants/constants.dart';

// import '../Logic/Models/conversation.dart';
// import '../Logic/Models/message.dart';

// void handleReceivedMessage(
//     List<Conversation> conversationsList, Message receivedMessage) {
//   try {
//     // Find the corresponding conversation based on the conversation ID
//     var conversation = conversationsList.firstWhere(
//       (c) => c.id == receivedMessage.conversationId,
//       orElse: () => defaultConvo,
//     );

//     // If the conversation exists, add the message to its message list
//     if (conversation != defaultConvo) {
//       if (!conversation.messages.contains(receivedMessage)) {
//         conversationsList[conversationsList.indexOf(conversation)]
//             .messages
//             .add(receivedMessage);
//       }
//     } else {
//       // If the conversation doesn't exist, create a new one with the received message
//       var newConversation = Conversation(
//         id: receivedMessage.conversationId,
//         users: [
//           receivedMessage.sender,
//           receivedMessage.receiver
//         ], // Add appropriate users data here
//         messages: [receivedMessage], // Add the received message
//       );

//       // Add the new conversation to the list
//       conversationsList.add(newConversation);
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }
