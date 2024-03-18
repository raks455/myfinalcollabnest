const express = require('express');
const router = express.Router();
const sentEmailController = require('../controller/sentemailController');

router.post('/api/sent-emails', sentEmailController.saveSentEmail);
router.get('/api/sent-emails', sentEmailController.getSentEmails);
router.post('/api/received-emails', sentEmailController.saveReceivedEmail);
router.get('/api/received-emails', sentEmailController.getReceivedEmails);

module.exports = router;
