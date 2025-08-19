const io = require('socket.io-client');
const socket = io('http://<VM1_PUBLIC_IP>:3000');  // Replace with VM1 IP

socket.on('connect', () => {
  console.log('Connected to chat server');
  socket.emit('chat message', 'Hello from VM2!');
});

socket.on('chat message', (msg) => {
  console.log('Received: ' + msg);
});

// Simulate sending messages
setInterval(() => {
  socket.emit('chat message', 'Ping from client!');
}, 5000);
