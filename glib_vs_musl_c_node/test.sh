docker container run --rm --read-only --user 1234:4212 -v ./test.js:/test.js:ro docker.io/library/node:20.19.3-alpine /test.js;

docker container run --rm --read-only --user 1234:4212 -v ./test.js:/test.js:ro docker.io/library/node:20.19.3-slim   /test.js;

docker image build . -t chustos.io/static/node:20.19.3 -f node.Dockerfile;
docker container run --rm --read-only --user 1234:4212 -v ./test.js:/test.js:ro chustos.io/static/node:20.19.3        /test.js;

docker image build . --tag chustos.io/static/node:20.19.3-musl --file node.musl.Dockerfile;
docker container run --rm --read-only --user 1234:4212 -v ./test.js:/test.js:ro chustos.io/static/node:20.19.3-musl   /test.js;


trivy image chustos.io/static/node:20.19.3
trivy image node:20.19.3-slim
trivy image node:20.19.3-alpine

#wget https://github.com/aquasecurity/trivy/releases/download/v0.63.0/trivy_0.63.0_Linux-64bit.tar.gz
# tar -xf trivy_0.63.0_Linux-64bit.tar.gz