#!/bin/bash
set -e
echo "Starting installation on ChatVM1"

# Install Node.js 20.x
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get update
sudo apt-get install -y nodejs

# Verify installation
node -v >> /home/azureuser/install.log
npm -v >> /home/azureuser/install.log

# Create working directory
mkdir -p /home/azureuser/chat-app
cd /home/azureuser/chat-app

# Download chat app files from Gist
echo "Downloading app files..."
curl -o index.js https://raw.githubusercontent.com/artem-datainsights/azure-chat-demo/refs/heads/main/index.js >> /home/azureuser/install.log 2>&1
curl -o index.html https://raw.githubusercontent.com/artem-datainsights/azure-chat-demo/refs/heads/main/index.html >> /home/azureuser/install.log 2>&1

# Verify downloads
ls -l index.js index.html >> /home/azureuser/install.log

# Install dependencies
echo "Installing npm dependencies..."
npm install express@4 socket.io@4 >> /home/azureuser/install.log 2>&1

# Kill any process using port 3000
echo "Checking for port 3000 conflicts..."
if lsof -i :3000; then
  echo "Killing process on port 3000..."
  kill -9 $(lsof -t -i :3000) || echo "No process found on port 3000"
fi

# Start the server in the background
echo "Starting chat server..."
nohup node index.js > server.log 2>&1 &
sleep 2
if ps aux | grep '[n]ode index.js'; then
  echo "Chat server started on port 3000" >> /home/azureuser/install.log
else
  echo "Failed to start server, check server.log" >> /home/azureuser/install.log
  cat server.log >> /home/azureuser/install.log
  exit 1
fi
