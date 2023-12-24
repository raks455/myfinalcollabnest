const AdminModel = require("../models/admin.model");
const jwt = require("jsonwebtoken");
const UserModel = require("../models/user.model");
class AdminServices{

    static async registerAdmin(email,userid,fullname,organization,password){
        try{
                console.log("-----Email -Username-- Password-----",email,userid,fullname,organization,password);
                
                const createAdmin = new AdminModel({email,userid,fullname,organization,password});
                return await createAdmin.save();
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
    static async getUserById(userId) {
        try {
          return await UserModel.findById(userId);
        } catch (error) {
          throw error;
        }
      }
    
      static async updateUser(userId, updatedData) {
        try {
          // Assuming updatedData is an object containing the fields to be updated
          return await UserModel.findByIdAndUpdate(userId, updatedData, { new: true });
        } catch (error) {
          throw error;
        }
      }
    
      static async deleteUser(userId) {
        try {
          return await UserModel.findByIdAndDelete(userId);
        } catch (error) {
          throw error;
        }
      }
}


module.exports = AdminServices;