# Use Nginx as base image
FROM nginx:latest

# Install Git and Node.js + npm
RUN apt-get update && apt-get install -y git nodejs npm

# Set working directory for clone/build
WORKDIR /app

# Clone repo
RUN git clone https://github.com/Dimethoxy/Scales.git .

# Install deps and build
RUN npm install && npm run build

# Clean nginx content dir and copy built files
RUN rm -rf /usr/share/nginx/html/* && \
    cp -r build/* /usr/share/nginx/html/

# Expose nginx port
EXPOSE 80

# Create update+rebuild script for container startup
RUN echo "#!/bin/sh" > /update.sh && \
    echo "cd /app && git pull && npm install && npm run build && cp -r build/* /usr/share/nginx/html/" >> /update.sh && \
    chmod +x /update.sh

# Run update script and then start nginx
CMD /update.sh && nginx -g 'daemon off;'
