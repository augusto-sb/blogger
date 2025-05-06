FROM docker.io/node:20.19.1-alpine3.21 AS builder
WORKDIR /builder/
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY index.html .
COPY vite.config.js .
COPY public/ ./public/
COPY src/ ./src/
ENV VITE_MESSAGE=REPLACE_VITE_MESSAGE
RUN npm run build -- --base /context/path/



FROM docker.io/nginxinc/nginx-unprivileged:1.28.0-alpine-slim AS server
COPY --from=builder /builder/dist/ /usr/share/nginx/html/
COPY script.sh /docker-entrypoint.d/40-script.sh
USER root
RUN chown nginx -R /usr/share/nginx/html/
RUN chmod +x /docker-entrypoint.d/40-script.sh
USER nginx