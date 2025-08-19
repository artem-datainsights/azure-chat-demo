#!/bin/bash
set -e  # Exit on error
echo "Starting installation on ChatVM1"

# Install Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get update
sudo apt-get install -y nodejs

# Verify Node.js and npm
node -v
npm -v

# Create working directory
mkdir -p /home/azureuser/chat-app
cd /home/azureuser/chat-app

# Download Socket.IO chat app files
curl -o index.js https://raw.githubusercontent.com/socketio/socket.io/main/examples/chat/index.js
curl -o index.html https://raw.githubusercontent.com/socketio/socket.io/main/examples/chat/index.html

# Install dependencies
npm install express@4 socket.io@4

# Start the server in the background
nohup node index.js &
echo "Chat server started on port 3000"
