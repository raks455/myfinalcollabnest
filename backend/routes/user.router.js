const router = require("express").Router();
const UserController = require('../controller/user.controller');

router.post("/register",UserController.register);

router.post("/login", UserController.login);
router.put("/:userId", UserController.updateUser); // Update user details
router.delete("/:userId", UserController.deleteUser); // Delete user

module.exports = router;