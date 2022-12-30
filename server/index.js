const express = require("express");
const { set, connect } = require("mongoose");
const cors = require("cors");
// const http = require("http");
// const Socket = require("socket.io");

const app = express();

const server = require('http').createServer(app);
const io = require('socket.io')(server);

const authRouter = require('./routes/auth.js');
const documentRouter = require("./routes/document.js");
const Document = require("./models/document");

const PORT = process.env.PORT | 3001;

// const server = http.createServer(app);
// var io = Socket(server);
// const io = new Server(server);

const DB = "mongodb://mo15hammed:test1234@ac-o3brnfv-shard-00-00.mfpttzg.mongodb.net:27017,ac-o3brnfv-shard-00-01.mfpttzg.mongodb.net:27017,ac-o3brnfv-shard-00-02.mfpttzg.mongodb.net:27017/?ssl=true&replicaSet=atlas-pjb91r-shard-0&authSource=admin&retryWrites=true&w=majority";
set('strictQuery', false);
connect(DB).then(() => {
    console.log('DB Connected successfully!');
}).catch((e) => {
    console.log(e);
});

io.on('connection', client => {
    console.log('connected to socket: ', client.id);
    client.on('join', (documentId) => {
        client.join(documentId);
        console.log('joined!', documentId);
    });

    client.on('typing', (data) => {
        client.broadcast.to(data.room).emit("changes", data);
        console.log('typing!');
    });

    client.on('save', (data) => {
        saveData(data);
        console.log('save!');
    });

});

const saveData = async (data) => {
    let doc = await Document.findById(data.room);
    doc.content = data.delta;
    doc = await doc.save();
}

server.listen(PORT, "0.0.0.0", () => { 
    console.log(`CONNECTED at port ${PORT}`);
});

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);