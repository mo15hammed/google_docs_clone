const express = require("express");
const mongoose = require("mongoose");

const PORT = process.env.PORT | 3001;

const DB = "mongodb://mo15hammed:test1234@ac-o3brnfv-shard-00-00.mfpttzg.mongodb.net:27017,ac-o3brnfv-shard-00-01.mfpttzg.mongodb.net:27017,ac-o3brnfv-shard-00-02.mfpttzg.mongodb.net:27017/?ssl=true&replicaSet=atlas-pjb91r-shard-0&authSource=admin&retryWrites=true&w=majority";
mongoose.set('strictQuery', false);
mongoose.connect(DB).then(() => {
    console.log('DB Connected successfully!');
}).catch((e) => {
    console.log(e);
});

const app = express();
app.listen(PORT, "0.0.0.0", () => {
    console.log(`CONNECTED at port ${PORT}`);

});