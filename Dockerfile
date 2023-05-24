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
RUN python3.7 -m pip install --upgrade pip

# Install basic python dependencies
RUN python3.7 -m pip install jupyter wheel setuptools numpy pygame

# Set up a Jupyter Notebook configuration
RUN jupyter notebook --generate-config

# Generate a self-signed SSL certificate (optional)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /root/mykey.key -out /root/mycert.pem \
    -subj "/C=IT/ST=Lombardy/L=Milan/O=Politecnico di Milano/OU=NECSTLab/CN=localhost"

# Switch back to the carla user
USER carla

# Install the carla PythonAPI
# TODO: find a way to install without needing the exact name of the wheel file
RUN python3.7 -m pip install PythonAPI/carla/dist/carla-0.9.14-cp37-cp37m-manylinux_2_27_x86_64.whl

# Patching agents implementation in carla PythonAPI  
COPY ./carla/PythonAPI/carla/agents/navigation/* /home/carla/PythonAPI/carla/agents/navigation/

# Install requirements for the agents
RUN python3.7 -m pip install -r /home/carla/PythonAPI/carla/requirements.txt

# Copy the simulator source code and setup file
RUN mkdir -p /home/carla/driver-aggressiveness-simulator/src/
COPY ./src/* /home/carla/driver-aggressiveness-simulator/src/
COPY ./README.md /home/carla/driver-aggressiveness-simulator/
COPY ./setup.py /home/carla/driver-aggressiveness-simulator/

# Build and install the Python package "dasimulator"
WORKDIR /home/carla/driver-aggressiveness-simulator
RUN python3.7 setup.py bdist_wheel sdist
RUN python3.7 -m pip install -e .

# Set the working directory for the Jupyter Notebook
WORKDIR /home/carla/driver-aggressiveness-simulator

# Expose the Jupyter Notebook port
EXPOSE 8888

# Start the Jupyter Notebook server
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--certfile=/root/mycert.pem", "--keyfile=/root/mykey.key"]
