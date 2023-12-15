const express = require("express");
const bodyParser = require("body-parser");
const UserRoute = require("./routes/user.router");
const ToDoRoute = require('./routes/todo.router');
const ProjectRoute=require('./routes/project.router');
const ProductRoute=require("./routes/app.router");
const app = express();
const cors = require('cors');


// Enable Cross-Origin Resource Sharing (CORS)
app.use(cors());

// Parse JSON request bodies
app.use(bodyParser.json());

// Routes
app.use("/", UserRoute); 
app.use("/api",ProductRoute);// User-related routes
app.use("/", ToDoRoute); // ToDo-related routes
app.use("/",ProjectRoute);
app.use("/uploads", express.static("uploads"));

// Export the app instance

module.exports = app;
