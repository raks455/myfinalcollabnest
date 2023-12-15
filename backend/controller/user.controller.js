const UserServices = require('../services/user.service');

exports.register = async (req, res, next) => {
    try {
        console.log("---req body---", req.body);
        const { email,username,password,fullname,organization } = req.body;
        const duplicate = await UserServices.getUserByEmail(email);
        if (duplicate) {
            throw new Error(`UserName ${email}, Already Registered`)
        }
        const response = await UserServices.registerUser(email,username,fullname,organization,password);

        res.json({ status: true, success: 'User registered successfully' });


    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.login = async (req, res, next) => {
    try {

        const { email, password } = req.body;

        if (!email || !password) {
            throw new Error('Parameter are not correct');
        }
        let user = await UserServices.checkUser(email);
        if (!user) {
            throw new Error('User does not exist');
        }

        const isPasswordCorrect = await user.comparePassword(password);

        if (isPasswordCorrect === false) {
            throw new Error(`Username or Password does not match`);
        }

        // Creating Token

        let tokenData;
        tokenData = { _id: user._id, email: user.email ,username:user.username,fullname:user.fullname,organization:user.organization};
    

        const token = await UserServices.generateAccessToken(tokenData,"secret","1h")

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
        const {   password,  } = req.body;
console.log(userId);
        // Check if the user exists
        const user = await UserServices.getUserById(userId);
        if (!user) {
            throw new Error('User not found');
        }

        // Update user details
        const updatedUser = await UserServices.updateUser(userId, {
           
            password,
          
        });

        res.json({ status: true, success: 'User details updated successfully', user: updatedUser });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
   
}
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