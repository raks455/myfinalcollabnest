const {deleteProject} = require("../controller/project.controller");
const ProjectModel = require("../models/project.model");

class ProjectService{
    static async createProject(userId,title,description,timestamp){
            const createProject = new ProjectModel({userId,title,description,timestamp});
            return await createProject.save();
    }

    static async getProjectList(userId){
        const projectList = await ProjectModel.find({userId})
        return projectList;
    } static async getAllProjectList(){
        const projectList = await ProjectModel.find()
        return projectList;
    }

   static async deleteProject(id){
        const deleted = await ProjectModel.findByIdAndDelete({_id:id})
        return deleted;
   }
}

module.exports = ProjectService;