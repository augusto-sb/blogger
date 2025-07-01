VERSION='3.0.16';
docker image build . -t chustos.io/static/openssl:3.0.16 -f Dockerfile; # --build-arg VERSION=3.0.16 # --build-arg VERSION=${VERSION}
docker container run --rm --read-only chustos.io/static/openssl:3.0.16;
docker image inspect chustos.io/static/openssl:3.0.16;

REGISTRY='chustos.io';
PROJECT='static';
APP='openssl';
IMAGE="${REGISTRY}/${PROJECT}/${APP}:${VERSION}";
docker container run --rm --read-only ${IMAGE} req -new -newkey rsa:2048 -days 365 -nodes -x509 -subj "/C=US/ST=CA/L=San Francisco/O=Example LLC/OU=IT Dept/CN=exmaple.org/emailAddress=it@exmaple.org" -keyout /dev/stdout;