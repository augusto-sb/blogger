#estandarizar path por ej: '', '/context', '/context/path'
OLDIFS=$IFS;
IFS='/';
standarized_path='';
for part in $CONTEXT_PATH; do
    if [ "$part" = "" ]; then
       echo "ignoring";
    else
       standarized_path=$standarized_path'/'$part;
    fi;
done;
echo "standarized_path: $standarized_path";
IFS=$OLDIFS;
find /usr/share/nginx/html/ -type f -exec sed -i "s@/context/path@${standarized_path}@g" {} +;

#reemplazar envs que empiezan con VITE_
for env in $(env | awk -F "=" '{print $1}' | grep "VITE_.*"); do
    echo "replacing: key: ${env} - val: $(printenv $env)"
    find /usr/share/nginx/html/ -type f -exec sed -i "s@REPLACE_${env}@$(printenv $env)@g" {} +;
done;