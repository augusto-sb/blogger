docker image pull docker.io/library/postgres:15.13-alpine;

docker image pull quay.io/keycloak/keycloak:26.2.5-0;

docker volume create keycloak --driver local;

docker network create keycloak --driver bridge;

docker container run --detach --network keycloak --name kc-database --volume keycloak:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=dbpass -e POSTGRES_USER=dbuser -e POSTGRES_DB=kcdb docker.io/library/postgres:15.13-alpine;

sleep 16;

# uses port 7800
# or -Djgroups.dns.query=keycloak

docker container run --detach --network keycloak --name kc-1 -p 8080:8080 -e KC_HTTP_ENABLED=true -e KC_DB=postgres \
  -e KC_DB_PASSWORD=dbpass -e KC_DB_USERNAME=dbuser -e KC_DB_URL=jdbc:postgresql://kc-database:5432/kcdb --hostname kchost \
  -e KC_CACHE=ispn -e KC_CACHE_STACK=kubernetes -e jgroups.dns.query=kchost -e KC_HOSTNAME_STRICT=false \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  quay.io/keycloak/keycloak:26.2.5-0 start;

docker container create --network keycloak --name kc-2 -p 8081:8080 -e KC_HTTP_ENABLED=true -e KC_DB=postgres \
  -e KC_DB_PASSWORD=dbpass -e KC_DB_USERNAME=dbuser -e KC_DB_URL=jdbc:postgresql://kc-database:5432/kcdb --hostname kchost \
  -e KC_CACHE=ispn -e KC_CACHE_STACK=kubernetes -e jgroups.dns.query=kchost -e KC_HOSTNAME_STRICT=false \
  quay.io/keycloak/keycloak:26.2.5-0 start;

sleep 32;

docker container exec kc-1 /opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user admin --password admin;
clientId=$(docker container exec kc-1 /opt/keycloak/bin/kcadm.sh create clients -r master -s clientId=test -s 'directAccessGrantsEnabled=true' -s 'publicClient=true' -i);
#set direct access grants for client account in master realm

# crea una session
TOKEN=$(curl --no-progress-meter -d "client_id=test" -d "username=admin" -d "password=admin" -d "grant_type=password" "http://localhost:8080/realms/master/protocol/openid-connect/token" -H 'Host: localhost:8080' 2>/dev/null | cut -d '"' -f4);
# el header Host conviene setearlo si hacemos requests a los keycloaks a distinto host para no tener error por el issuer

docker container start kc-2;

sleep 16;

docker container stop kc-1;

docker container exec kc-2 /opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user admin --password admin;

docker container exec kc-2 /opt/keycloak/bin/kcadm.sh get ui-ext/sessions;

docker container stop kc-2 kc-database;

docker container rm kc-1 kc-2 kc-database;

docker network rm keycloak;

docker volume rm keycloak;