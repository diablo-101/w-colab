#!/bin/bash

# Set password
echo -e "$123\n$123\n" | sudo passwd

# Clean up previous installations
rm -rf ngrok ngrok.zip ng.sh > /dev/null 2>&1

# Download ngrok
wget -O ng.sh https://bit.ly/GCngrok > /dev/null 2>&1
chmod +x ng.sh
./ng.sh

# Clear the screen
clear

# Ngrok region selection
echo "======================="
echo "Choose ngrok region"
echo "======================="
echo "us - United States (Ohio)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "Choose ngrok region: " CRP

# Check if CRP is set
if [ -z "$CRP" ]; then
    echo "No region selected, exiting."
    exit 1
fi

# Start ngrok tunnel
echo "Starting ngrok with region $CRP..."
./ngrok tcp --region "$CRP" 3388 &

# Wait for ngrok to initialize
sleep 10

# Check if ngrok is running
if ! pgrep -f "ngrok"; then
    echo "ngrok failed to start"
    exit 1
fi

# Install Docker image
echo "===================================="
echo "Install RDP"
echo "===================================="
docker pull danielguerra/ubuntu-xrdp

# Clear the screen
clear

# Start Docker container
echo "===================================="
echo "Start RDP"
echo "===================================="
docker run --rm -p 3388:3389 danielguerra/ubuntu-xrdp:kali &

# Wait for Docker to initialize
sleep 10

# Output RDP credentials
echo "===================================="
echo "Username : ubuntu"
echo "Password : ubuntu"
echo "RDP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
if [ $? -ne 0 ]; then
    echo "Failed to retrieve ngrok tunnel address"
    exit 1
fi
echo "===================================="
echo "Don't close this tab to keep RDP running"
echo "Keep support akuh.net thank you"
echo "Wait 1 minute to finish bot"
echo "===================================="
