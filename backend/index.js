const app = require("./app");
const cors = require('cors');
const db = require('./config/db')
const port = 3000;
app.listen(port,()=>{
    console.log(`Server Listening on Port http://localhost:${port}`);
})