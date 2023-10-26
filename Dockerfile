FROM ubuntu:20.04

# Actualizar los repositorios
RUN sed -i 's/hirsute/focal/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y

# Instalar Python y pip
RUN apt-get install -y python3 python3-pip

COPY ./app /app

# Copiar el archivo del modelo al directorio de trabajo
COPY model.h5 /app/model.h5

# Copiar el archivo de requisitos al directorio de trabajo
COPY requirements.txt /app/requirements.txt

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar las dependencias y las versiones específicas de TensorFlow y Keras
RUN pip3 install -r requirements.txt

# Exponer puerto
EXPOSE 8080

# Entrypoint y comando
ENTRYPOINT ["python3", "main.py"]
CMD ["serve"]