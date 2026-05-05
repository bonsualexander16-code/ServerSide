FROM node:18-slim

ENV NODE_ENV=production
ENV NPM_CONFIG_LOGLEVEL=error

# Install system deps + yt-dlp in one layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg python3 python3-pip && \
    pip3 install -U --no-cache-dir yt-dlp && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files first (cache optimization)
COPY package*.json ./
RUN npm ci --omit=dev

# Copy rest of app
COPY . .

# Create non-root user and fix permissions
RUN useradd -m -u 1001 appuser && \
    mkdir -p /app/downloads && \
    chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

CMD ["npm", "start"]