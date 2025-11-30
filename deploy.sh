#!/bin/bash
# Stop old container if exists
docker rm -f react-app 2>/dev/null

# Run new container
docker run -d --name react-app -p 80:80 maruvarasivasu/react-app-dev:latest
echo "React app deployed successfully on port 80!"
