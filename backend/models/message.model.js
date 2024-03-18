



const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;

const messageSchema = new Schema({
 
  sender: String,
  receiver: String,
  message: String,
  timestamp: { type: Date, default: Date.now }
});

const Message = db.model('Message', messageSchema);

module.exports = Message;
