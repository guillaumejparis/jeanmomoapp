# --- Stage 1: Build Flutter Web App ---
FROM dart:stable AS build
WORKDIR /app

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter --version

# Copy only pubspec files first for caching
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the app
COPY . .

# Build the web release
RUN flutter build web --wasm --release --base-href /

# --- Stage 2: Serve with Nginx ---
FROM nginx:1.25-alpine AS production
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
