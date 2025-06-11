npm i minio

docker image pull quay.io/minio/minio:RELEASE.2025-05-24T17-08-30Z
docker image inspect quay.io/minio/minio:RELEASE.2025-05-24T17-08-30Z

docker compose up -d

curl localhost:8080

curl localhost:8080/minio/

node test.js

docker compose stop