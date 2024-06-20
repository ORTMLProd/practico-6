FROM ubuntu:20.04

# Update repositories
RUN sed -i 's/hirsute/focal/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y

# Install Python and pip
RUN apt-get install -y python3 python3-pip

# Copy the model file to the working directory
COPY model.h5 /app/model.h5

# Copy the application and requirements file to the working directory
COPY ./app /app
COPY requirements.txt /app/requirements.txt

# Set the working directory
WORKDIR /app

# Install dependencies
RUN pip3 install -r requirements.txt

# Expose the port
EXPOSE 8080

# Entrypoint and command
ENTRYPOINT ["python3", "main.py"]
CMD ["serve"]
