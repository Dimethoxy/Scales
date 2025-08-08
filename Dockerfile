# Use Node 22 as base image
FROM node:22-alpine

# Install dependencies for nginx and git
RUN apk add --no-cache nginx git curl

# Set working directory
WORKDIR /app

# Create startup script
RUN echo "#!/bin/sh" > /startup.sh && \
    echo "echo '[DEBUG] Cleaning /app directory...'" >> /startup.sh && \
    echo "rm -rf /app && mkdir /app && cd /app" >> /startup.sh && \
    echo "echo '[DEBUG] Cloning repository...'" >> /startup.sh && \
    echo "git clone https://github.com/Dimethoxy/Scales.git . || exit 1" >> /startup.sh && \
    echo "echo '[DEBUG] Installing dependencies and building...'" >> /startup.sh && \
    echo "npm install --legacy-peer-deps && npm run build || exit 1" >> /startup.sh && \
    echo "echo '[DEBUG] Cleaning nginx html directory...'" >> /startup.sh && \
    echo "rm -rf /var/lib/nginx/html/*" >> /startup.sh && \
    echo "echo '[DEBUG] Copying build output to nginx html directory...'" >> /startup.sh && \
    echo "cp -r build/* /var/lib/nginx/html/" >> /startup.sh && \
    echo "echo '[DEBUG] Cleaning up /app directory...'" >> /startup.sh && \
    echo "cd / && rm -rf /app" >> /startup.sh && \
    echo "echo '[DEBUG] Starting nginx...'" >> /startup.sh && \
    echo "exec nginx -g 'daemon off;'" >> /startup.sh && \
    chmod +x /startup.sh

# Copy default nginx config
RUN mkdir -p /var/lib/nginx/html

# Expose nginx port
EXPOSE 80

# Start script + nginx
CMD ["/startup.sh"]
