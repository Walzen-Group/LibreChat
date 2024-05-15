# v0.7.2

# Base node image
FROM node:20-alpine AS node

RUN apk --no-cache add curl

RUN mkdir -p /app && chown node:node /app
WORKDIR /app

# Allow mounting of these files, which have no default
# values.
RUN touch .env

# Trying to fix ECONNRESET error
RUN npm cache clean --force
RUN rm -rf node_modules
RUN rm -f package-lock.json
RUN npm install
# Install call deps - Install curl for health check
RUN apk --no-cache add curl && \
    mkdir /.npm && \
    chown -R 99:100 /.npm && \
    npm ci

RUN mkdir -p /app/client/public/images /app/api/logs

# Node API setup
EXPOSE 3080
ENV HOST=0.0.0.0
CMD ["npm", "run", "backend"]

# Optional: for client with nginx routing
# FROM nginx:stable-alpine AS nginx-client
# WORKDIR /usr/share/nginx/html
# COPY --from=node /app/client/dist /usr/share/nginx/html
# COPY client/nginx.conf /etc/nginx/conf.d/default.conf
# ENTRYPOINT ["nginx", "-g", "daemon off;"]
