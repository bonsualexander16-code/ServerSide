FROM node:18-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        python3 \
        python3-pip \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install yt-dlp safely
RUN pip3 install --no-cache-dir -U yt-dlp

# Set working directory
WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Install Node dependencies
RUN npm install --omit=dev

# Copy rest of the app
COPY . .

# Expose port
EXPOSE 5000

# Start app
CMD ["npm", "start"]
