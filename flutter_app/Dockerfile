# Stage 1 - Build Flutter app
FROM ubuntu:20.04 AS build

WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y git curl xz-utils zip

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter

# Add Flutter to path
ENV PATH="/flutter/bin:$PATH"

# Enable web support for Flutter
RUN flutter config --enable-web

# Run flutter doctor to check setup
RUN flutter doctor

# Copy app source code
COPY . .

# Build the web version of the app
RUN flutter build web

# Stage 2 - Serve the app using Nginx
FROM nginx:alpine

# Copy the built Flutter web app to Nginx's default html directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80 to serve the web app
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
