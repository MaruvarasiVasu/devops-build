#!/bin/bash
# Build Docker images for dev and prod

echo "Building Dev image..."
docker build -t maruvarasivasu/react-app-dev:latest .

echo "Building Prod image..."
docker build -t maruvarasivasu/react-app-prod:latest .

echo "Docker images built successfully!"
