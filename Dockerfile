# Set up an Nginx web server
FROM nginx:alpine

# Copy the built web assets to the Nginx document root
COPY build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
