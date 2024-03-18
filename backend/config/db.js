
const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb://127.0.0.1:27017/ToDoDB', {
 
  serverSelectionTimeoutMS: 15000,

})
  .on('open', () => {
    console.log('MongoDB Connected');
  })
  .on('error', (error) => {
    console.error('MongoDB Connection error:', error);
  })
  .on('disconnected', () => {
    console.log('MongoDB Disconnected');
  });

module.exports = connection;
