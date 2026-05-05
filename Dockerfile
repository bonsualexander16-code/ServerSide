# Use a smaller official Node.js image
FROM node:18-slim

# Install ffmpeg (cleaned to reduce image size)
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy package files first (better Docker cache)
COPY package*.json ./

# Install dependencies (clean install is more reliable in Docker)
RUN npm install

# Copy all project files
COPY . .

# Expose app port
EXPOSE 5000

# Start the app
CMD ["npm", "start"]
