# Starting from the official carla image
FROM carlasim/carla:0.9.14

# Install Python and necessary dependencies
USER root
RUN apt-get update && \
    apt-get install -y python3.7 python3-pip && \
    apt-get clean
# Set Python 3.7 as default interpreter
RUN ln -sfn /usr/bin/python3.7 /usr/bin/python

# Upgrade pip
RUN pip3 install --upgrade pip

# Install Jupyter Notebook
RUN pip3 install jupyter

# Set up a Jupyter Notebook configuration
RUN jupyter notebook --generate-config

# Generate a self-signed SSL certificate (optional)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /root/mykey.key -out /root/mycert.pem \
    -subj "/C=IT/ST=Lombardy/L=Milan/O=Politecnico di Milano/OU=NECSTLab/CN=localhost"

# Install wheel and setuptools for Python package building
RUN pip3 install wheel
RUN pip3 install setuptools

# Patching agents implementation in carla PythonAPI  
COPY ./carla/PythonAPI/carla/agents/navigation/* /home/carla/PythonAPI/carla/agents/navigation/

# FIXME: temporary copy of Python source code
RUN mkdir -p /home/carla/driver-aggressiveness-simulator/src/
COPY ./src/* /home/carla/driver-aggressiveness-simulator/src/
COPY ./README.md /home/carla/driver-aggressiveness-simulator/
COPY ./setup.py /home/carla/driver-aggressiveness-simulator/

# TODO: generate Python package
# Build and install the Python package "dasimulator"
WORKDIR /home/carla/driver-aggressiveness-simulator
RUN python3 setup.py bdist_wheel sdist
RUN ls
RUN ls /usr/local/lib
RUN pip3 install dist/*.whl

USER carla

# Set the working directory for the Jupyter Notebook
WORKDIR /home/carla/driver-aggressiveness-simulator

# Expose the Jupyter Notebook port
EXPOSE 8888

# Start the Jupyter Notebook server
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--certfile=/root/mycert.pem", "--keyfile=/root/mykey.key"]
