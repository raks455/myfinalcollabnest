// const express = require('express');
// const messageController = require('../controller/message.controller');

// const router = express.Router();

// router.post('/api/sendMessage', messageController.sendMessage);
// router.get('/api/getMessages', messageController.getMessages);
// // router.post('/', messageController.sendMessage);
// // router.get('/:sender/:receiver', messageController.getMessages);
// // router.get('/getchathistory/:_id',messageController.getChatHistory);
// // router.put('/updatechathistory/:_id',messageController.updateChatHistory);
// // router.post('/savechathistory/:_id',messageController.saveChatHistory);
// // router.get('/getidbyfullname/:fullname',messageController.getUserIdByFullName);
// module.exports = router;
const express = require('express');
const router = express.Router();
const messageController = require('../controller/message.controller');

router.post('/messages', messageController.sendMessage);
router.get('/messages/:sender/:receiver', messageController.getMessages);

module.exports = router;
