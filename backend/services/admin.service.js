const AdminModel = require("../models/admin.model");
const jwt = require("jsonwebtoken");
const UserModel = require("../models/user.model");
class AdminServices{

    static async registerAdmin(email,userid,fullname,organization,password){
        try{
                console.log("-----Email -Username-- Password-----",email,userid,fullname,organization,password);
                
                const createAdmin = new UserModel({email,userid,fullname,organization,password});
                return await createAdmin.save();
        }catch(err){
            throw err;
        }
    }
    static async getAllUsers() {
      try {
        return await UserModel.find();
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
            return await AdminModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateAccessToken(tokenData,JWTSecret_Key,JWT_EXPIRE){
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
    }
    static async getUserById(_id,includePassword = false) {
        try {
          let query=UserModel.findById(_id);
        
          if (!includePassword) {
            // Exclude the password field if includePassword is false
            query = query.select('-password');
          }
          return await query.exec();

        } catch (error) {
          throw error;
        }
      }
    
     
      
      static async updateUser(_id, updatedData) {
        try {
          // Assuming updatedData is an object containing the fields to be updated
          if (updatedData.password) {
            // Hash the password if it is included in the updatedData
           
            const saltRounds = 20;
    
            // Hash the password and update the updatedData object
            const hashedPassword = await bcrypt.hash(updatedData.password, saltRounds);
            updatedData.password = hashedPassword;
    
           
          }
    
          // Now update the user in the database
          const updatedUser = await UserModel.findByIdAndUpdate(_id, updatedData, { new: true });
    
    
          return updatedUser;
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
}


module.exports = AdminServices;