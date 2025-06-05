rm main;
rustc -o main ./main.rs;
WHOAMI_PORT_NUMBER=8080 ./main;
WHOAMI_PORT_NUMBER=asdasdasd ./main;
WHOAMI_NAME=asdasdasd ./main;

# docker run --rm -p 8080:80 -e WHOAMI_NAME=aaaaa traefik/whoami:v1.11.0
# 2025/06/05 13:29:54 Starting up on port 80

# docker run --rm -p 8080:80 -e WHOAMI_PORT_NUMBER=aaaaa traefik/whoami:v1.11.0
# 2025/06/05 13:29:27 Starting up on port aaaaa
# 2025/06/05 13:29:27 listen tcp: lookup tcp/aaaaa: unknown port

# curl localhost:8080
# Name: aaaaa
# Hostname: 9422b06f811d
# IP: 127.0.0.1
# IP: ::1
# IP: 172.17.0.2
# RemoteAddr: 172.17.0.1:54398
# GET / HTTP/1.1
# Host: localhost:8080
# User-Agent: curl/8.5.0
# Accept: */*