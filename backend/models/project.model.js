const db = require('../config/db');
const UserModel = require("./user.model");
const mongoose = require('mongoose');
const { Schema } = mongoose;

const projectSchema = new Schema({
    userId:{
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName
    },
    title: {
        type: String,
        required: true
    },
    description: {
        type: String,
        required: true
    },
   timestamp:{
    type:Date,
   default:Date.now,
    required:true
   }
},{timestamps:true});

const ProjectModel = db.model('project',projectSchema);
module.exports = ProjectModel;