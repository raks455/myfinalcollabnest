const ProjectService = require('../services/project.service');

exports.createProject =  async (req,res,next)=>{
    try {
        const { userId,title, description,timestamp } = req.body;
        let projectData = await ProjectService.createProject(userId,title, description,timestamp);
        res.json({status: true,success:projectData});
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}

exports.getProjectList =  async (req,res,next)=>{
    try {
        const { userId } = req.body;
        let projectData = await ProjectService.getProjectList(userId);
        res.json({status: true,success:projectData});
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}

exports.deleteProject =  async (req,res,next)=>{
    try {
        const { id } = req.body;
        let deletedData = await ProjectService.deleteProject(id);
        res.json({status: true,success:deletedData});
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}