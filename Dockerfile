# Use Nginx base image
FROM nginx:alpine

# Remove default Nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy the pre-built build folder from devops-build into Nginx html
COPY devops-build/build/ /usr/share/nginx/html

# Optional: copy _redirects if it exists (skip if not)
# COPY devops-build/_redirects /usr/share/nginx/html/_redirects

# Optional: custom Nginx config for React Router
# COPY devops-build/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
