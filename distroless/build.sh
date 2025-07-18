docker image build . --tag chustos.io/distroless/minio:RELEASE.2025-06-13T11-33-47Z --file minio.Dockerfile --platform linux/amd64;
docker container run --rm -p 9000:9000 -p 9001:9001 --tmpfs /data chustos.io/distroless/minio:RELEASE.2025-06-13T11-33-47Z version;

docker image build . --tag chustos.io/distroless/mongod:6.0.25 --file mongod.Dockerfile --platform linux/amd64;
docker container run --rm  chustos.io/distroless/mongod:6.0.25 --version;
# you can start with --no-auth, create an admin user, and recreate de container without --no-auth

docker image build . --tag chustos.io/distroless/postgres:15.13 --file postgres.Dockerfile --platform linux/amd64;
docker container run --rm chustos.io/distroless/postgres:15.13 --version