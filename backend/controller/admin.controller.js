const AdminServices = require('../services/admin.service');
const UserServices = require('../services/user.service');
const nodemailer = require('nodemailer');
const bcrypt = require('bcrypt');

exports.register = async (req, res, next) => {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: 'santusharma1278@gmail.com',
          pass: 'oehc yjfl rbek ayuy',
        },
      });
    async function sendRegistrationEmail(email, userid, password) {
        const mailOptions = {
          from: 'CollabNest',
          to: email,
          subject: 'Welcome to CollabNest!',
          text: `Hello ${userid},\n\n` +
            'Thank you for registering with CollabNest!\n\n' +'You can login with these details and start your journey with collabnest'+
            'Your login credentials:\n' +
            `Username: ${userid}\n` +
            `Password: ${password}\n\n` +
            'You can now log in using these credentials.Please keep this credentials safe and don\'t share it with anyone \n Team, \n CollabNest',
        };
      
        try {
          const info = await transporter.sendMail(mailOptions);
          console.log('Message sent: %s', info.messageId);
        } catch (error) {
          console.error('Error sending email:', error);
        }
      }
    try {
        console.log("---req body---", req.body);
        const { email,userid,password,fullname,organization,role } = req.body;
        const duplicate = await UserServices.getUserByEmail(email);
    
        if (duplicate) {
            throw new Error(`User ${email}, Already Registered`)
        }
        const response = await UserServices.registerUser(email,userid,fullname,organization,password,role);
        await sendRegistrationEmail(email, userid, password);
        res.json({ status: true, success: 'User registered successfully' });


    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.login = async (req, res, next) => {
    try {

        const { email, password,userid } = req.body;

        if (!email || !password || !userid) {
            throw new Error('Parameter are not correct');
        }
        let user = await AdminServices.checkUser(email);
        if (!user) {
            throw new Error('User does not exist');
        }

        const isPasswordCorrect = await user.comparePassword(password);

        if (isPasswordCorrect === false) {
            throw new Error(`Username or Password does not match`);
        }

        // Creating Token

        let tokenData;
        tokenData = { _id: user._id, email: user.email ,userid:user.userid,fullname:user.fullname,organization:user.organization,password:user.password,role:user.role};
    

        const token = await AdminServices.generateAccessToken(tokenData,"secret","1h")

        res.status(200).json({ status: true, success: "sendData", token: token });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}
// Import necessary modules


exports.updateUser = async (req, res, next) => {
    try {
        const _id = req.params._id; // Assuming userId is part of the route path
        const {password,email,fullname,userid,organization,role} = req.body;
console.log(_id);
        // Check if the user exists
        const user = await UserServices.getUserById(_id);
        if (!user) {
            throw new Error('User not found');
        }

        // Update user details
        const updatedUser = await UserServices.updateUser(_id, {
           
            password,email,fullname,userid,organization,role
          
        });

        res.json({ status: true, success: 'User details updated successfully', user: updatedUser });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
   
}

exports.getAllUsers = async (req, res, next) => {
    try {
        const users = await UserServices.getAllUsers();
        res.status(200).json(users);
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Internal Server Error' });
        next(error);
    }
};
exports.deleteUser = async (req, res, next) => {
    try {
        const _id = req.params._id; // Assuming userId is part of the route path
        // Check if the user exists
        const user = await UserServices.getUserById(_id);
        if (!user) {
            throw new Error('User not found');
        }

        // Delete user
        await UserServices.deleteUser(_id);

        res.json({ status: true, success: 'User deleted successfully' });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.getUserById = async (req, res, next) => {
    try {
        const userId = req.params._id; // Use a different variable name, e.g., userId

        // Check if the user exists
        const user = await UserServices.getUserById(userId);

        if (!user) {
            throw new Error('User not found');
        }

        // Extract the fields you want to include in the response
        const { _id, email, userid, fullname, organization, password, is_admin, isDeleted,role, is_verified, createdAt, updatedAt, __v } = user;
console.log(user.password);
        // Create a response object with the desired fields
        const userResponse = {
            _id,
            email,
            userid,
            role,
            fullname,
            organization,
            password, // Include the password field if needed
            is_admin,
            isDeleted,
            is_verified,
            createdAt,
            updatedAt,
            __v
        };
console.log(userResponse.fullname);
        res.json({ status: true, success: 'User retrieved successfully', user: userResponse });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};
exports.getFullNameById = async (req, res, next) => {
    try {
        const userId = req.params._id; // Use a different variable name, e.g., userId

        // Check if the user exists
        const user = await UserServices.getUserById(userId);

        if (!user) {
            throw new Error('User not found');
        }

        // Extract the fields you want to include in the response
        const { fullname} = user;
console.log(user.password);
        // Create a response object with the desired fields
        const userResponse = {
           
            fullname,
         
        };
console.log(userResponse.fullname)
        res.json({ status: true, success: 'User retrieved successfully', user: userResponse });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};
