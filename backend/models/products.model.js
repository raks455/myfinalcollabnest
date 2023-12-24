
const db = require('../config/db');
const UserModel = require("./user.model");
const mongoose = require('mongoose');
const { Schema } = mongoose;

const projectSchema = new Schema({
    userId:{
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName
    },
    productName: {
        type: String,
        required: true
    },
    productDescription: {
        type: String,
        required: true
    },
    productPrice:{
        required:true,
type:Number
    },
    productImage:{
        required:true,
        type:String
    },
    timestamp:{
        type:Date,
       default:Date.now,
        required:true
       }
   
},{timestamps:true});

const product= db.model('product',projectSchema);
module.exports = product;