const UserModel = require("../models/user.model");
const jwt = require("jsonwebtoken");

class UserServices{

    static async registerUser(email,userid,fullname,organization,password,role){
        try{
                console.log("-----Email -Username-- Password-----",email,userid,fullname,organization,password,role);
                
                const createUser = new UserModel({email,userid,fullname,organization,password,role});
                return await createUser.save();
        }catch(err){
            throw err;
        }
    }
    static async getAllUsers() {
      try {
        return await UserModel.find({}).select('-password');
      } catch (error) {
        throw error;
      }
    }
    static async getUserByEmail(email){
        try{
            return await UserModel.findOne({email});
        }catch(err){
            console.log(err);
        }
    }

    static async checkUser(email){
        try {
            return await UserModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateAccessToken(tokenData,JWTSecret_Key,JWT_EXPIRE){
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
    }
    static async getUserById(_id) {
        try {
          return await UserModel.findById(_id);
        } catch (error) {
          throw error;
        }
      }
    
     
      static async updateUser(_id, updatedData) {
        try {
          // Assuming updatedData is an object containing the fields to be updated
          return await UserModel.findByIdAndUpdate(_id, updatedData, { new: true });
        } catch (error) {
          throw error;
        }
      }
    
      static async deleteUser(_id) {
        try {
          return await UserModel.findByIdAndDelete(_id);
        } catch (error) {
          throw error;
        }
      }
      static async getUserIdByFullname(fullname) {
        try {
            const user = await UserModel.findOne({ fullname });
            return user ? user._id : null;
        } catch (error) {
            throw error;
        }
    }
    
}


module.exports = UserServices;