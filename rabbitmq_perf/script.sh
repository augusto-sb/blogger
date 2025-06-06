FILE_PATH="./perf-test-2.23.0.jar";

if [ -f "$FILE_PATH" ]; then
	echo "Regular file '$FILE_PATH' exists.";
else
	echo "Regular file '$FILE_PATH' does not exist.";
	wget https://github.com/rabbitmq/rabbitmq-perf-test/releases/download/v2.23.0/perf-test-2.23.0.jar;
fi

docker compose -f docker-compose-3.yml up --abort-on-container-exit --exit-code-from perf > output-3.txt;

docker compose -f docker-compose-3.yml rm --force;

docker network rm rabbitmq_perf_default;

# rm perf-test-2.23.0.jar