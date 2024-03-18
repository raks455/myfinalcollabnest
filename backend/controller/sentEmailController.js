const SentEmail = require('../models/sentEmail');
const ReceivedEmail=require("../models/receivedEmail")
exports.saveSentEmail = async (req, res) => {
  try {
    const { to, subject, body } = req.body;
    const sentEmail = new SentEmail({ to, subject, body });
    await sentEmail.save();
    res.status(200).json({ message: 'Email saved successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};

exports.getSentEmails = async (req, res) => {
  try {
    const sentEmails = await SentEmail.find();
    res.status(200).json(sentEmails);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};
exports.saveReceivedEmail = async (req, res) => {
  try {
    const { from, subject, body } = req.body;
    const receivedEmail = new ReceivedEmail({ from, subject, body });
    await receivedEmail.save();
    res.status(200).json({ message: 'Received Email saved successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};

exports.getReceivedEmails = async (req, res) => {
  try {
    const receivedEmails = await ReceivedEmail.find();
    res.status(200).json(receivedEmails);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};