#!/bin/bash
set -e
echo "Starting installation on ChatVM1"

# Install Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get update
sudo apt-get install -y nodejs

# Verify installation
node -v
npm -v

# Create working directory
mkdir -p /home/azureuser/chat-app
cd /home/azureuser/chat-app

# Download chat app files from Gist
curl -o index.js YOUR_GIST_INDEX_JS_URL
curl -o index.html YOUR_GIST_INDEX_HTML_URL

# Verify downloads
ls -l index.js index.html

# Install dependencies
npm install express@4 socket.io@4

# Start the server in the background
nohup node index.js > server.log 2>&1 &
sleep 2
if ps aux | grep '[n]ode index.js'; then
  echo "Chat server started on port 3000"
else
  echo "Failed to start server, check server.log"
  cat server.log
  exit 1
fi
