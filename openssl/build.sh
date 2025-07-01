docker image build . -t chustos.io/static/openssl:3.0.16 -f Dockerfile;
docker container run --rm --read-only chustos.io/static/openssl:3.0.16;
docker image inspect chustos.io/static/openssl:3.0.16;