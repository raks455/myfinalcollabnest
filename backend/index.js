const app = require("./app");
const cors = require('cors');
const db = require('./config/db');
const port = 4000;
app.set('view engine', 'ejs');
app.listen(port,()=>{
    console.log(`Server Listening on Port http://localhost:${port}`);
})