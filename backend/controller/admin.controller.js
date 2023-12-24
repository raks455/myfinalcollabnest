const AdminServices = require('../services/admin.service');
const UserServices = require('../services/user.service');
const nodemailer = require('nodemailer');
exports.register = async (req, res, next) => {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: 'santusharma1278@gmail.com',
          pass: 'idxr navf rrim bqcz',
        },
      });
    async function sendRegistrationEmail(email, userid, password) {
        const mailOptions = {
          from: 'santusharma1278@gmail.com',
          to: email,
          subject: 'Welcome to CollabNest!',
          text: `Hello ${userid},\n\n` +
            'Thank you for registering with CollabNest!\n\n' +'You can login with these details and start your journey with collabnest'+
            'Your login credentials:\n' +
            `Username: ${userid}\n` +
            `Password: ${password}\n\n` +
            'You can now log in using these credentials.Please keep this credentials safe and don\'t share it with anyone',
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
        const { email,userid,password,fullname,organization } = req.body;
        const duplicate = await AdminServices.getUserByEmail(email);
    
        if (duplicate) {
            throw new Error(`Admin ${email}, Already Registered`)
        }
        const response = await AdminServices.registerAdmin(email,userid,fullname,organization,password);
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
        tokenData = { _id: user._id, email: user.email ,userid:user.userid,fullname:user.fullname,organization:user.organization};
    

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
        const userId = req.params.userId; // Assuming userId is part of the route path
        const {password,email} = req.body;
console.log(userId);
        // Check if the user exists
        const user = await UserServices.getUserById(userId);
        if (!user) {
            throw new Error('User not found');
        }

        // Update user details
        const updatedUser = await UserServices.updateUser(userId, {
           
            password,email,fullname
          
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
        const userId = req.params.userId; // Assuming userId is part of the route path

        // Check if the user exists
        const user = await UserServices.getUserById(userId);
        if (!user) {
            throw new Error('User not found');
        }

        // Delete user
        await UserServices.deleteUser(userId);

        res.json({ status: true, success: 'User deleted successfully' });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}