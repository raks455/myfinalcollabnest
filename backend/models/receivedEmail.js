const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;
const receivedEmailSchema = new Schema({
    from: String,
    subject: String,
    body: String,
    receivedOn: { type: Date, default: Date.now },
  });
  module.exports = db.model('ReceivedEmail', receivedEmailSchema);