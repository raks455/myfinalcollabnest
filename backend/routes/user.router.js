const router = require("express").Router();
const express = require("express");
const UserController = require('../controller/user.controller');
const app = express();
router.post("/register",UserController.register);
app.set('view_engine','ejs');
app.set('views','./views/users');

router.post("/login", UserController.login);
router.put("/updateuser", UserController.updateUser); // Update user details
router.delete("/deleteuser", UserController.deleteUser); // Delete user
router.get('/getallusers',UserController.getAllUsers);
module.exports = router;