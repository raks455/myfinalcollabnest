const router = require("express").Router();
const express = require("express");
const AdminController = require('../controller/admin.controller');
const app = express();
router.post("/registeradmin",AdminController.register);
app.set('view_engine','ejs');
app.set('views','./views/users');

router.post("/adminlogin", AdminController.login);
router.put("/updateuser", AdminController.updateUser); // Update user details
router.delete("/deleteuser", AdminController.deleteUser); // Delete user
router.get('/getallusers',AdminController.getAllUsers);
module.exports = router;