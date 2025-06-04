#include <stdio.h>      // printf, perror
#include <stdlib.h>     // exit, EXIT_FAILURE
#include <string.h>     // memset, memcpy (no usada aquí pero útil)
#include <unistd.h>     // close, read, write, sleep
#include <errno.h>      // errno, perror
#include <signal.h>     // signal, sig_atomic_t, SIGINT
#include <sys/types.h>  // tipos básicos de sockets (e.g., socklen_t)
#include <sys/socket.h> // socket, bind, listen, accept, setsockopt
#include <netinet/in.h> // sockaddr_in, htons, INADDR_ANY
#include <sys/select.h> // select, fd_set, FD_* macros, struct timeval
#include <time.h> // nanosleep
#include <stdbool.h> // bool

// definitiones

#define HEADER_KEY_LENGTH 16
#define BUFFER_SIZE 1024
#define MAX_HEADERS 16

// types

struct Header {
	char key[HEADER_KEY_LENGTH];
	char value[256];
};

struct Request {
	char method[8];
	char path[1024];
	char version[16];
	struct Header headers[MAX_HEADERS];
	char queryParams[1024];
	char body[1024];
	//fragment
};

// globals

volatile sig_atomic_t stop = 0;



struct Request* parse_http_request(const char *requestBuff) {
	struct Request* req = malloc(sizeof(struct Request));
	int i = 0, offset;

	while(requestBuff[i] != '\0' && requestBuff[i] != ' '){
		req->method[i] = requestBuff[i];
		i++;
	}
	if(requestBuff[i] == '\0'){
		return NULL;
	}else{
		req->method[i] = '\0';
	}
	i++;
	offset = i;
	bool queryParams = false;
	while(requestBuff[i] != '\0' && requestBuff[i] != ' '){
		if(queryParams){
			req->queryParams[i-offset] = requestBuff[i];
		}else{
			if(requestBuff[i] == '?'){
				queryParams = true;
				offset = i+1;
			}else{
				req->path[i-offset] = requestBuff[i];
			}
		}
		i++;
	}
	if(requestBuff[i] == '\0'){
		return NULL;
	}else{
		req->path[i-offset] = '\0';
	}
	i++;
	offset = i;
	while(requestBuff[i] != '\0' && requestBuff[i] != '\r'){
		req->version[i-offset] = requestBuff[i];
		i++;
	}
	if(requestBuff[i] == '\0' || requestBuff[i+1] != '\n'){
		return NULL;
	}else{
		req->version[i-offset] = '\0';
	}
	i += 2;
	offset = i;
	bool body = false;
	int headerPos = 0;
	bool headerValue = false;
	while(requestBuff[i] != '\0'){
		if(body){
			req->body[i-offset] = requestBuff[i];
		}else{
			if(requestBuff[i] == '\r'){
				if(requestBuff[i+1] == '\n'){
					req->headers[headerPos].value[i-offset] = '\0'; // close value string
					i += 2;
					if(requestBuff[i] == '\r' && requestBuff[i+1] == '\n'){
						body = true;
						i += 2;
					}else{
						headerPos++;
						headerValue = false;
					}
					offset = i;
					continue;
				}else{
					//error
					break;
				}
			}
			if(headerPos < MAX_HEADERS){
				if(!headerValue){
					if(requestBuff[i] == ':' && requestBuff[i+1] == ' '){
						req->headers[headerPos].key[i-offset] = '\0'; // close key string
						i += 2;
						headerValue = true;
						offset = i;
						continue;
					}else{
						req->headers[headerPos].key[i-offset] = requestBuff[i];
					}
				}else{
					req->headers[headerPos].value[i-offset] = requestBuff[i];
				}
			}else{
				printf("discarded header");
			}
		}
		i++;
	}
	req->body[i-offset] = '\0';
	return req;
}



// Señal para interrumpir el bucle
void handle_sigint(int sig) {
	stop = 1;
}



void handle_client(int client_fd) {
	char buffer[BUFFER_SIZE];
	int bytes_read = 0;
	struct Request* req = NULL;
	int lala;

	// Leer la solicitud del cliente (HTTP)
	bytes_read = read(client_fd, buffer, BUFFER_SIZE);
	if(bytes_read == BUFFER_SIZE){
		const char *bad_response = "HTTP/1.1 400 Bad Request\r\n\r\nrequest too long!\r\n";
		write(client_fd, bad_response, strlen(bad_response));
		return;
	}

	if (bytes_read > 0) {
		buffer[bytes_read] = '\0';
		req = parse_http_request(buffer);
		if(req == NULL){
			const char *bad_response = "HTTP/1.1 400 Bad Request\r\n\r\nmalformed request!\r\n";
			write(client_fd, bad_response, strlen(bad_response));
			perror("BAD REQ");
			return;
		}

		char response[2048];
		int offset = 0;
		offset += sprintf(response + offset, "HTTP/1.1 200 OK\r\n\r\nmethod: %s\npath: %s\nversion: %s\nqueryParams: %s\n", req->method, req->path, req->version, req->queryParams);
		for(int asd=0 ; asd<MAX_HEADERS ; asd++){
			if(strcmp("", req->headers[asd].key) == 0){
				break;
			}
			offset += sprintf(response + offset, "header: %s: %s\n", req->headers[asd].key, req->headers[asd].value);
		}
		offset += sprintf(response + offset, "body: %s\n",req->body);
		write(client_fd, response, strlen(response));

		free(req);
	}
}

int main() {
	struct sockaddr_in address;
	int opt = 1;
	int server_fd;
	fd_set readfds;
	struct timeval timeout;
	int activity;

	signal(SIGINT, handle_sigint); // Ctrl+C para cerrar

	if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
		perror("socket failed");
		exit(EXIT_FAILURE);
	}

	setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons(8080);

	if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
		perror("bind failed");
		exit(EXIT_FAILURE);
	}

	if (listen(server_fd, 3) < 0) {
		perror("listen failed");
		exit(EXIT_FAILURE);
	}

	while (!stop) {
		FD_ZERO(&readfds);
		FD_SET(server_fd, &readfds);
		timeout.tv_sec = 1;  // Espera 1 segundo
		timeout.tv_usec = 0;
		activity = select(server_fd + 1, &readfds, NULL, NULL, &timeout);

		if (activity < 0 && errno != EINTR) {
			perror("select");
			break;
		}

		if (activity == 0) {
			// Timeout
			continue;
		}

		if(stop){
			break;
		}

		if (FD_ISSET(server_fd, &readfds)) {
			int new_socket;
			socklen_t addrlen = sizeof(address);
			new_socket = accept(server_fd, (struct sockaddr *)&address, &addrlen);
			if (new_socket < 0) {
				perror("accept");
				continue;
			}
			handle_client(new_socket);
			close(new_socket);
		}
	}
	close(server_fd);
	return 0;
}
