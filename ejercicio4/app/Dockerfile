FROM python:3.11.5

# Directorio de trabajo en el contenedor
WORKDIR /app


# Copia los archivos de la aplicación al contenedor
COPY . .

# Crea el entorno virtual e instala las dependencias de la aplicación
RUN python3 -m venv venv \
    && . venv/bin/activate \
    && pip install -e .

RUN chmod +x entrypoint.sh

