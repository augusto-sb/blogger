distintas formas de armar un RS de mongodb

1) sin auth, usando red de bridge, necesita resolver los nombres que usamos para armar el rs
2) sin auth, usando red de bridge, no necesita resolver nombres porque lo hacemos mediante ips
3) sin auth, usando red de host, podemos usar localhost
4) con keyFile, falta implementar la creacion de user, red de host

etapa final Sharding
usamos replication: replica la info en todos los nodos (salvo arbitrier) y si pasa algo no perdes info

sharding distribuye la info en varios RS por si es mucha cantidad, por ejemplo si tenemos 2 rs guarda mitad en cada uno por asi decirlo

https://www.mongodb.com/docs/manual/sharding/

necesita 3 componentes, https://www.mongodb.com/docs/manual/core/sharded-cluster-components/

shard (cada RS que guarda info)
query router (mongos)
config (RS tambien se recomienda)

5) sharding.yml sin auth para prueba simple, sin problema de dns porque nos comunicamos solo con mongos, entre ellos si resuelven bien
# arbiter no se recomienda
# 3 rs de config, un router, 3 rs de shard
# rsC (replica set de config) rsS (replica set de sharding)