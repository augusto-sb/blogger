FROM docker.io/nginxinc/nginx-unprivileged:1.28.0-alpine-slim
COPY ./ngapp/dist/ngapp/browser/ /usr/share/nginx/html/