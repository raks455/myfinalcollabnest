const db = require('../config/db');
const bcrypt = require("bcrypt");
const mongoose = require('mongoose');
const { Schema } = mongoose;

const adminSchema = new Schema({
    email: {
        type: String,
        lowercase: true,
        required: [true, "Email can't be empty"],
        // @ts-ignore
        match: [
            /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
            "Email format is not correct",
        ],
        unique: true,
    },
    userid:{
        type: String,
        required: [true, "UserID can't be empty"],
        unique: true,
        // Use a regex pattern for the username
        match: [
            /^[\w@]+\d*$/, // Regex pattern allowing letters, @ symbol, and numbers
            "UserID format is not correct",
        ],
    },
    fullname:{
        type:String,
        required:[true,"Name of user is required"]
    },
    organization:{
type:String,
required:[true,"Organization name is required"]
    },
    password: {
        type: String,
        required: [true, "password is required"],
      validate: {
            validator: function (password) {
                // Validate password criteria (e.g., minimum length, at least one number, and one capital letter)
                const hasNumber = /\d/.test(password);
                const hasCapitalLetter = /[A-Z]/.test(password);

                return password.length >= 8 && hasNumber && hasCapitalLetter;
            },
            message: 'Password must be at least 8 characters long and contain at least one number and one capital letter.',
        },
    },
    is_admin: {
        type: Boolean,
        default: true, // Set default value to false for regular users
      },
    isDeleted: {
        type: Number,
        default: false,
    },
    is_verified:{
type:Number,
default:0
    },
   
    lastUpdated: {
        type: Date,
    },
},{timestamps:true});


// used while encrypting user entered password
adminSchema.pre("save",async function(){
    var user = this;
    if(!user.isModified("password")){
        return
    }
    try{
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(user.password,salt);

        user.password = hash;
    }catch(err){
        throw err;
    }
});


//used while signIn decrypt
adminSchema.methods.comparePassword = async function (candidatePassword) {
    try {
        console.log('----------------no password',this.password);
        // @ts-ignore
        const isMatch = await bcrypt.compare(candidatePassword, this.password);
        return isMatch;
    } catch (error) {
        throw error;
    }
};

const AdminModel = db.model('admin',adminSchema);
module.exports = AdminModel;
