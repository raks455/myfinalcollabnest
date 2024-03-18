const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;
const sentEmailSchema = new Schema({
  to: String,
  subject: String,
  body: String,
  sentOn: { type: Date, default: Date.now },
});

module.exports = db.model('SentEmail', sentEmailSchema);

