#!/bin/bash
sudo apt update 
sudo apt install nginx -y
sudo systemctl start nginx
NGINX_CONF_PATH="/etc/nginx/nginx.conf"
# Write the NGINX configuration to the file
sudo cat <<EOL > $NGINX_CONF_PATH
worker_processes 1;

events {
    worker_connections 1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    upstream react_app {
        server 127.0.0.1:3000;
    }

    server {
        listen 80;
        #server_name your_domain.com; # Replace with your domain

        location / {
            proxy_pass http://react_app;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;

            # Optional settings to handle websockets
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
        }
    }
}
EOL
# Test the NGINX configuration for syntax errors
sudo nginx -t
# Reload NGINX to apply the new configuration
sudo systemctl reload nginx
nginx -s reload
echo "NGINX configuration updated and service reloaded."