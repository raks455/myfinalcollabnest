const router = require("express").Router();
const ToDoController = require('../controller/todo.controller')

router.post("/createToDo",ToDoController.createToDo);

router.post('/getUserTodoList',ToDoController.getToDoList)

router.post("/deleteTodo",ToDoController.deleteToDo)

module.exports = router;