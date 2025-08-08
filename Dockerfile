# Use nginx base image
FROM nginx:alpine

# Define nginx html path as a constant
ARG NGINX_HTML_PATH=/usr/share/nginx/html

# Install Node.js 22 and other dependencies
RUN apk add --no-cache git curl && \
    # Install Node.js 22 from the official Alpine package repository
    apk add --no-cache nodejs npm

# Set working directory
WORKDIR /app

# Create nginx html directory
RUN mkdir -p ${NGINX_HTML_PATH}

# Create startup script
RUN echo "#!/bin/sh" > /startup.sh && \
    echo "echo '[DEBUG] Cleaning /app directory...'" >> /startup.sh && \
    echo "rm -rf /app && mkdir /app && cd /app" >> /startup.sh && \
    echo "echo '[DEBUG] Cloning repository...'" >> /startup.sh && \
    echo "git clone https://github.com/Dimethoxy/Scales.git . || exit 1" >> /startup.sh && \
    echo "echo '[DEBUG] Installing dependencies and building...'" >> /startup.sh && \
    echo "npm install --legacy-peer-deps && npm run build || exit 1" >> /startup.sh && \
    echo "echo '[DEBUG] Cleaning nginx html directory...'" >> /startup.sh && \
    echo "rm -rf ${NGINX_HTML_PATH}/*" >> /startup.sh && \
    echo "echo '[DEBUG] Create HTML folder...'" >> /startup.sh && \
    echo "mkdir -p ${NGINX_HTML_PATH}" >> /startup.sh && \
    echo "echo '[DEBUG] Copying build output to nginx html directory...'" >> /startup.sh && \
    echo "cp -r build/* ${NGINX_HTML_PATH}" >> /startup.sh && \
    echo "echo '[DEBUG] Cleaning up /app directory...'" >> /startup.sh && \
    echo "cd / && rm -rf /app" >> /startup.sh && \
    echo "echo '[DEBUG] Content of ${NGINX_HTML_PATH}:'" >> /startup.sh && \
    echo "ls -la ${NGINX_HTML_PATH}" >> /startup.sh && \
    echo "echo '[DEBUG] Starting nginx...'" >> /startup.sh && \
    chmod +x /startup.sh

# Expose nginx port
EXPOSE 80

# Start Nginx and run the update script
CMD /startup.sh && nginx -g 'daemon off;'
