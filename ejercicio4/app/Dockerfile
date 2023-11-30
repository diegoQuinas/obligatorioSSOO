FROM python:3.11.5

# Directorio de trabajo en el contenedor
WORKDIR /app


# Copia los archivos de la aplicación al contenedor
COPY . /app

# Crea el entorno virtual e instala las dependencias de la aplicación
RUN python3 -m venv venv \
    && . venv/bin/activate \
    && pip install -e . \
    && export FLASK_APP=flaskr \
    && export FLASK_ENV=development \
    && flask init-db

# Exponer el puerto en el que Flask ejecuta la app (cambia esto según la configuración de tu app Flask)
EXPOSE 5000

# Ejecutar la aplicación Flask
CMD ["flask","run","--host=0.0.0.0", "--port=8080"]
