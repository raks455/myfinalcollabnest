
const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;
const UserModel = require("./user.model");
const postSchema = new mongoose.Schema({
 
 
  userId:{
    type: Schema.Types.ObjectId,
    ref: UserModel.modelName
},
  
    content: { type: String, required: true },
  likes:[  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: UserModel.modelName
    },
  },],
   comments: [{ type: String }],
  // comments: [
  //   {
  //     comment: {
  //       type: String,
  //       required: true,
  //     },
  //     userId: {
  //       type: Schema.Types.ObjectId,
  //       ref:UserModel.modelName, // Assuming userId is a string, adjust if needed
  //       required: true,
  //     },
  //     fullname: {
  //       type: String,
  //       ref:UserModel.modelName,
  //       required: true,
  //     },
  //   }
  // ],
  pictures: [{ type: String }],
    
  timestamp:{
    type:Date,
   default:Date.now,
    required:true
   }
  
  
  
});

const Post = db.model('Post', postSchema);

module.exports = Post;
