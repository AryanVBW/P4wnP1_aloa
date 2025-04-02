#!/bin/bash

# Set your Raspberry Pi's IP address here
PI_IP="172.16.0.1"  # Default USB Ethernet IP
# PI_IP="172.24.0.1"  # Default WiFi IP
# PI_IP="172.26.0.1"  # Default Bluetooth IP

# Ensure we're using Go 1.17.13 via goenv
export PATH="$HOME/.goenv/bin:$PATH"
eval "$(goenv init -)"
goenv shell 1.17.13

# Verify Go version
echo "Using Go version: $(go version)"

# Install GopherJS if needed
if ! command -v gopherjs &> /dev/null; then
    echo "Installing GopherJS..."
    go install github.com/gopherjs/gopherjs@v1.17.2
fi

# Build the web app with GopherJS
echo "Building web app with GopherJS..."
gopherjs build -o ../build/webapp.js -v

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "Build successful! Deploying to P4wnP1..."
    
    # Deploy to P4wnP1
    scp ../build/webapp* root@$PI_IP:/usr/local/P4wnP1/www/
    scp ../dist/www/index.html root@$PI_IP:/usr/local/P4wnP1/www/
    scp ../dist/www/p4wnp1.css root@$PI_IP:/usr/local/P4wnP1/www/
    
    echo "Deployment complete! Access the web interface at http://$PI_IP:8000"
else
    echo "Build failed. Please check for errors."
fi
