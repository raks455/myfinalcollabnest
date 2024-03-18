
// // const Message = require('../models/message.model');
// // const http = require('http');


// // const getUserIdByFullName =  (fullname) => {
// //   try {
// //     console.log(fullname);

// //     const response =  http.get(`http://localhost:4001/getidbyfullname/samsher%20limbu`);
// // console.log(response.body._id);
// //     if (response.statusCode === 200) {
// //       const responseBody = JSON.parse(response.body);

// //       // Check if the response body is not null and contains the expected field
// //       if (responseBody && responseBody._id) {
// //         return responseBody._id;
// //         console.log(responseBody._id);
// //       } else {
// //         // Handle the case where the expected field is not present in the response
// //         console.error('Error: Missing _id field in the response body');
// //         return null;
// //       }
// //     } else {
// //       console.error(`Error: Failed to get _id (${response.statusCode})`);
// //       return null;
// //     }
// //   } catch (error) {
// //     console.error('Error getting user ID by full name:', error);
// //     return null;
// //   }
// // };



// // const sendMessage =async (req, res) => {
// //   try {
   
// //     const { sender, receiver, text,} = req.body;
// //   console.log(sender + receiver);
// //         const senderUserId =   await getUserIdByFullName(sender);
// //     const receiverUserId = await getUserIdByFullName(receiver);
// // console.log(senderUserId);
// //     if (senderUserId && receiverUserId) {
// //       const message = new Message({ sender: senderUserId, receiver: receiverUserId, text:text });
// //      message.save();
// //      console.log(message);
// //       console.log('Message saved successfully:', message);
// //       res.status(201).json({ message: 'Message sent successfully' });
// //     } else {
// //       console.error('Error: SenderUserId or ReceiverUserId is null');
// //       res.status(400).json({ error: 'SenderUserId or ReceiverUserId is null' });
// //     }
// //   } catch (error) {
// //     console.error('Error saving message:', error);
// //     res.status(500).json({ error: 'Internal server error' });
// //   }
// // };

// // const getMessages = async (req, res) => {
// //   try {
// //     const { sender, receiver } = req.params;
// //     const messages = await Message.find({
// //       $or: [
// //         { sender, receiver },
// //         { sender: receiver, receiver: sender },
// //       ],
// //     }).sort({ timestamp: 1 });
// //     res.json(messages);
// //   } catch (error) {
// //     console.error(error);
// //     res.status(500).json({ error: 'Internal server error' });
// //   }
// // };

// // const getChatHistory = async (req, res) => {
// //   try {
// //     const { _id } = req.params;
// //     const chatHistory = await Message.find({
// //       $or: [{ sender: _id }, { receiver: _id }],
// //     }).sort({ timestamp: 1 });
// //     res.json(chatHistory);
// //   } catch (error) {
// //     console.error(error);
// //     res.status(500).json({ error: 'Internal server error' });
// //   }
// // };

// // const updateChatHistory =async  (req, res) => {
// //   try {
// //     const { _id } = req.params;
// //     const { newMessage } = req.body;

// //     // Load existing chat history
// //     const chatHistory =await  Message.find({
// //       $or: [{ sender: _id }, { receiver: _id }],
// //     });

// //     // Add the new message to the chat history
// //     chatHistory.push(newMessage);

// //     // Save the updated chat history
// //    await  Message.updateMany(
// //       { $or: [{ sender: _id }, { receiver: _id }] },
// //       { $set: { chatHistory } }
// //     );

// //     res.json({ message: 'Chat history updated successfully' });
// //   } catch (error) {
// //     console.error(error);
// //     res.status(500).json({ error: 'Internal server error' });
// //   }
// // };

// // const saveChatHistory = async (req, res) => {
// //   try {
// //     const { _id } = req.params;
// //     const { chatHistory } = req.body;

// //     // Save the provided chat history for the user
// //    await  Message.updateMany(
// //       { $or: [{ sender: _id }, { receiver: _id }] },
// //       { $set: { chatHistory } }
// //     );

// //     res.json({ message: 'Chat history saved successfully' });
// //   } catch (error) {
// //     console.error(error);
// //     res.status(500).json({ error: 'Internal server error' });
// //   }
// // };

// // module.exports = { sendMessage, getMessages, getChatHistory, updateChatHistory, saveChatHistory ,getUserIdByFullName};
// const Message = require('../models/message.model');
// const jwt = require('jsonwebtoken');
// const http = require('http');
// exports.sendMessage = async (req, res) => {
//   try {
//     const { sender, receiver, message } = req.body;
//     const newMessage = new Message({ sender, receiver, message });
//     await newMessage.save();
//     res.status(201).json({ message: 'Message sent successfully' });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: 'Internal Server Error' });
//   }
// };

// // exports.getMessages = async (req, res) => {
// //   try {
// //     const { sender, receiver } = req.params;
// //     const messages = await Message.find({
// //       $or: [
// //         { sender, receiver },
// //         { sender: receiver, receiver: sender },
// //       ],
// //     }).sort({ timestamp: 1 }); // Sort by timestamp in ascending order
// //     res.status(200).json(messages);
// //   } catch (error) {
// //     console.error(error);
// //     res.status(500).json({ message: 'Internal Server Error' });
// //   }
// // };

// // exports.getMessages = async (req, res) => {
// //   try {
// //     const { sender, receiver } = req.params;
// //     const currentUser = req.user; // Assuming you have the current user's name in the request

// //     const messages = await Message.find({
// //       $and: [
// //         {
// //           $or: [
// //             { sender: currentUser, receiver },
// //             { sender: receiver, receiver: currentUser },
// //           ],
// //         },
// //       ],
// //     }).sort({ timestamp: 1 }); // Sort by timestamp in ascending order

// //     res.status(200).json(messages);
// //   } catch (error) {
// //     console.error(error);
// //     res.status(500).json({ message: 'Internal Server Error' });
// //   }
// // };

// exports.getMessages = async (req, res) => {
//   try {
//     const { sender, receiver } = req.params;
    
//     // Assuming the token is present in the request headers
    
//     if (!req.headers.authorization) {
//       return res.status(401).json({ message: 'Authorization header missing' });
//     }
//     const token = req.headers.authorization.split(' ')[1];
//     // Verify and decode the JWT token to extract the username
//     const decodedToken = jwt.verify(token, 'your-secret-key');
//     const currentUser = decodedToken.sub; // Assuming 'sub' contains the username

//     const messages = await Message.find({
//       $and: [
//         {
//           $or: [
//             { sender: currentUser, receiver },
//             { sender: receiver, receiver: currentUser },
//           ],
//         },
//       ],
//     }).sort({ timestamp: 1 }); // Sort by timestamp in ascending order

//     res.status(200).json(messages);
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: 'Internal Server Error' });
//   }
// };
const Message = require('../models/message.model');

exports.sendMessage = async (req, res) => {
  try {
    const { sender, receiver, message } = req.body;
    const newMessage = new Message({ sender, receiver, message });
    await newMessage.save();
    res.status(201).json({ message: 'Message sent successfully' });
    console.log(req.body);
    console.log(newMessage);
    console.log(res.json);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};


exports.getMessages = async (req, res) => {
  try {
    const { sender, receiver } = req.params;
    console.log('Sender:', sender);
    console.log('Receiver:', receiver);

    const messages = await Message.find({
      $or: [
        { sender, receiver },
        { sender: receiver, receiver: sender },
      ],
    }).sort({ timestamp: 1 });
    res.status(200).json(messages);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};
