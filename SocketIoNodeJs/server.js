var express = require('express');
//Create express app.
var app = express();
var server = require('http').Server(app);
var io = require('socket.io')(server);

var userList = [];
connections = [];

//Strating server.
server.listen(process.env.PORT || 8080);
console.log('Server is running... 8080');

io.on('connection', function(socket){
    connections.push(socket);
    console.log('Connect %s sockets are connected', connections.length);

    // Disconnect
    socket.on('disconnect', function(data){
        connections.splice(connections.indexOf(socket), 1)
        console.log('Disconnect %s sockets are connected', connections.length);
    });

    socket.on("connectUser", function(clientNickname) {
        var message = "User " + clientNickname + " was connected.";
        console.log(message);
  
        var userInfo = {};
        var foundUser = false;
        for (var i=0; i<userList.length; i++) {
          if (userList[i]["nickname"] == clientNickname) {
            userList[i]["isConnected"] = true
            userList[i]["id"] = socket.id;
            userInfo = userList[i];
            foundUser = true;
            break;
          }
        }
  
        if (!foundUser) {
          userInfo["id"] = socket.id;
          userInfo["nickname"] = clientNickname;
          userInfo["isConnected"] = true
          userList.push(userInfo);
        }
        io.emit("userList", userList);
    });

    socket.on('chatMessage', function(clientNickname, message){
      console.log("message", message)

      var currentDateTime = new Date().toLocaleString();
      io.emit('newChatMessage', clientNickname, message, currentDateTime);
    });
})
