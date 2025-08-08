# Use Nginx as base image
FROM nginx:latest

# Install Git and curl
RUN apt-get update && apt-get install -y git curl

# Set working directory
WORKDIR /app
        
# Create startup script
RUN echo "#!/bin/sh" > /startup.sh && \
    echo "rm -rf /app && mkdir /app && cd /app" >> /startup.sh && \
    echo "git clone https://github.com/Dimethoxy/Scales.git . || exit 1" >> /startup.sh && \
    echo "npm install --legacy-peer-deps && npm run build || exit 1" >> /startup.sh && \
    echo "rm -rf /usr/share/nginx/html/*" >> /startup.sh && \
    echo "cp -r build/* /usr/share/nginx/html/" >> /startup.sh && \
    echo "cd .." >> /startup.sh && \
    echo "rm -rf /app" >> /startup.sh && \
    chmod +x /startup.sh

# Expose nginx port
EXPOSE 80

# Run the startup script then launch nginx
CMD /startup.sh && nginx -g 'daemon off;'
