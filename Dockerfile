# Choose image
FROM node:lts-bullseye

# Choose working directory
WORKDIR /app

# Copy over dependencies
COPY package.json package.json
COPY package-lock.json package-lock.json
COPY src/ src

# npm run build
RUN npm run build

# Launch nginx
FROM nginx:bookworm
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/ /usr/share/nginx/html

# Change privileges on apache root
RUN chown -R www-data:www-data /usr/share/nginx/html \
    && sed -i "s/Listen 80/Listen \${PORT}/g" /etc/nginx/conf.d/default.conf