# Dockerfile — serve the static site with nginx (Alpine)
# Build context: project root containing index.html, styles.css, script.js

FROM nginx:alpine

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy site files into nginx html folder
COPY ./ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
