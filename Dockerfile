# Starting from the official carla image
FROM carlasim/carla:0.9.14

# Install Python and necessary dependencies
USER root
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean

# Install Jupyter Notebook
RUN pip3 install jupyter

# Set up a Jupyter Notebook configuration
RUN jupyter notebook --generate-config

# Generate a self-signed SSL certificate (optional)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /root/mykey.key -out /root/mycert.pem \
    -subj "/C=IT/ST=Lombardy/L=Milan/O=Politecnico di Milano/OU=NECSTLab/CN=localhost"

# Patching agents implementation in carla PythonAPI  
COPY ./carla/PythonAPI/carla/agents/navigation/* /home/carla/PythonAPI/carla/agents/navigation/
USER carla

# FIXME: temporary copy of Python source code
# TODO: generate Python package
RUN mkdir -p /home/carla/driver-aggressiveness-simulator/
COPY ./src/* /home/carla/driver-aggressiveness-simulator/
COPY ./requirements.txt /home/carla/driver-aggressiveness-simulator/
RUN python3 -m pip install -r /home/carla/driver-aggressiveness-simulator/requirements.txt

# Set the working directory for the Jupyter Notebook
WORKDIR /home/carla/driver-aggressiveness-simulator

# Expose the Jupyter Notebook port
EXPOSE 8888

# Start the Jupyter Notebook server
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--certfile=/root/mycert.pem", "--keyfile=/root/mykey.key"]
