con keycloak podemos mejorar la imagen oficial haciendo una imagen, en base a esta que ejecute el comando 'build' y luego en vez de iniciarla con el clasico 'start', la iniciemos con 'start --optimized'.

esto mejora bastante el tiempo de inicio, que si suelen trabajar con Keycloak sabran que puede rondar los 5 segundos

para iniciar keycloak incluye varios scripts, la imagen oficial inicia con:

docker image inspect quay.io/keycloak/keycloak:26.2.5-0 --format '{{.Config.Entrypoint}}'
[/opt/keycloak/bin/kc.sh]

por lo cual ya podemos ver que inicia con un shell (vulnerabilidades) y que trae cosas que no son estrictamente necesarias para su funcionamiento. lo cual tambien hace al tamaño y a la velocidad de inicio


tamaño
docker image inspect quay.io/keycloak/keycloak:26.2.5-0 --format='{{.Size}}'
451086510

para mejorarlo podemos realizar el build con las opciones que usemos en nuestro entorno productivo y luego usar una base, por ej distroless de java
#docker image inspect gcr.io/distroless/java17-debian12:nonroot

docker image inspect gcr.io/distroless/java21:nonroot

con un entrypoint que no sea un script de shell, si no el comando java que finalmente se ejecuta por eso

...

tenemos una imagen más liviana, más segura y que inicia mucho más rápido!


hay variables/argumentos que se usan a la hora de buildear otros solo a la hora de ejecutar como por ejemplo lo mas obvio la conexion a la base de datos

https://www.keycloak.org/server/containers
https://www.keycloak.org/server/all-config
https://dev.to/stack-labs/keycloak-on-distroless-12ng
https://github.com/kokuwaio/keycloak/blob/main/src/main/docker/Dockerfile
https://quay.io/repository/quarkus/quarkus-distroless-image?tab=tags&tag=latest
https://es.quarkus.io/guides/building-native-image



tambien se puede probar con la imagenes de sapmachine parecen mas livianas pero hay que quitarles el shell