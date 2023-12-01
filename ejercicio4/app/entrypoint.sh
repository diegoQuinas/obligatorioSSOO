#!/bin/sh

cd /app


if [ -f /app/instance/*.sqlite  ]; then
  echo "La base de datos ya fue inicializada"
else
  echo "Inicializando base de datos"
  flask init-db
fi

flask run --host=0.0.0.0 --port=8080
