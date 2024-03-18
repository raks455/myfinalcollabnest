const express = require("express");
const bodyParser = require("body-parser");
const EmailRoute=require("./routes/email.router");
const UserRoute = require("./routes/user.router");
const AdminRoute = require("./routes/admin.router");
const ToDoRoute = require('./routes/todo.router');
const ProjectRoute=require('./routes/project.router');
const app = express();
const cors = require('cors');
const messageRoutes = require('./routes/messageRoute');
const newsfeedRouter = require('./routes/post.route');

// Enable Cross-Origin Resource Sharing (CORS)
app.use(cors());

// Parse JSON request bodies
app.use(bodyParser.json());

// Routes
app.use("/", UserRoute); 
app.use("/", AdminRoute);
app.use('/api/posts', newsfeedRouter);
// User-related routes
app.use("/", ToDoRoute); // ToDo-related routes
app.use("/",ProjectRoute);
app.use('/', EmailRoute);
app.use('/', messageRoutes);
app.use("/uploads", express.static("uploads"));

module.exports = app;
