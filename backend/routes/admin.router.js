const router = require("express").Router();
const express = require("express");
const AdminController = require('../controller/admin.controller');

router.post("/registration",AdminController.register);

router.post("/adminlogin", AdminController.login);
router.put("/updateuser/:_id", AdminController.updateUser); // Update user details
router.delete("/deleteuser/:_id", AdminController.deleteUser); // Delete user
router.get('/getallusers',AdminController.getAllUsers);
router.get('/getuserbyid/:_id',AdminController.getUserById);
router.get('/getFullNameById/:_id',AdminController.getUserById);

module.exports = router;