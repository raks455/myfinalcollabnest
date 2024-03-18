const router = require("express").Router();
const express = require("express");
const UserController = require('../controller/user.controller');
const app = express();
router.post("/reegister",UserController.register);


router.post("/login", UserController.login);
router.put("/upddateuser/:_id", UserController.updateUser); // Update user details
router.delete("/deletteuser/:_id", UserController.deleteUser); // Delete user
router.get('/getalllusers',UserController.getAllUsers);
router.get('/getidbyfullname/:fullname', UserController.getUserIdByFullname);
module.exports = router;