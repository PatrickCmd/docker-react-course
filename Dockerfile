# Multi-step Builds
FROM node:alpine as builder
WORKDIR /app
COPY package.json .
RUN yarn install
COPY . .
RUN yarn run build

#/app/build/ =====> has all the production build files

# Working with nginx to server the production builds from
# the builder stage
# COPY --from=builder /app/build /usr/share/nginx/html ===> Copies contents from the build directory
# to the nginx share folder and serves it as static files
# See: https://hub.docker.com/_/nginx
# Testing out the nginx server
# docker build -t client .
# docker run -p 8080:80 client ====> Port 80 is the default port used by nginx to server http requests.
FROM nginx:1.17.8-alpine
COPY --from=builder /app/build /usr/share/nginx/html