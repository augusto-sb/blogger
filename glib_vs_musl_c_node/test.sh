docker container run --rm --read-only --user 1234:4212 -v ./test.js:/test.js:ro docker.io/library/node:20.19.3-alpine /test.js;

docker container run --rm --read-only --user 1234:4212 -v ./test.js:/test.js:ro docker.io/library/node:20.19.3-slim   /test.js;

docker image build . -t chustos.io/static/node:20.19.3 -f node.Dockerfile;
docker container run --rm --read-only --user 1234:4212 -v ./test.js:/test.js:ro chustos.io/static/node:20.19.3        /test.js;