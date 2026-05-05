FROM node:18-slim

# Install system dependencies (including yt-dlp from apt instead of pip)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        python3 \
        python3-pip \
        ca-certificates \
        curl \
        yt-dlp && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Install Node dependencies
RUN npm install --omit=dev

# Copy app source
COPY . .

# Expose your app port
EXPOSE 5000

# Start server
CMD ["npm", "start"]
