const router = require("express").Router();
const ProjectController = require('../controller/project.controller');
router.post("/createProject",ProjectController.createProject);
router.post('/getprojectList',ProjectController.getProjectList)
router.post('/getallprojectlist',ProjectController.getAllProjectList)
router.post("/deleteproject",ProjectController.deleteProject)

module.exports = router;