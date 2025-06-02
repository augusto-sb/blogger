# pasos

1) crear network y vol

2) crear postgres

3) iniciar un keycloak y crear otro pausado (con la config de cache compartida)

4) crear un client para poder generar un token

5) generar token (crea una sesion)

6) prender la segunda instancia, darle tiempo que se sincronize y apagar la primera

7) listar sesiones y ver que sigue activa

8) borrar recursos

```bash
bash script.sh > output.txt
```