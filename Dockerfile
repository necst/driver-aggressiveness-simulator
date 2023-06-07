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
RUN python -m pip install --upgrade pip

# Install basic python dependencies
RUN python -m pip install jupyter wheel setuptools 

# FIX: xdg-user-dir not found error
RUN apt-get install -y xdg-user-dirs xdg-utils && apt-get clean

# Switch back to the carla user
USER carla

# Set up a Jupyter Notebook configuration
RUN jupyter notebook --generate-config

# Generate a self-signed SSL certificate (optional)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /home/carla/mykey.key -out /home/carla/mycert.pem \
    -subj "/C=IT/ST=Lombardy/L=Milan/O=Politecnico di Milano/OU=NECSTLab/CN=localhost"


# Install the carla PythonAPI
RUN python -m pip install PythonAPI/carla/dist/carla-0.9.14-cp37-cp37m-manylinux_2_27_x86_64.whl

# Patching agents implementation in carla PythonAPI  
COPY ./carla/PythonAPI/carla/agents/navigation/* /home/carla/PythonAPI/carla/agents/navigation/

# Install requirements for the agents
RUN python -m pip install -r /home/carla/PythonAPI/carla/requirements.txt && \
    python -m pip install pygame

# Copy the simulator source code and setup file
RUN mkdir -p /home/carla/driver-aggressiveness-simulator/src/
COPY ./src/* /home/carla/driver-aggressiveness-simulator/src/
COPY ./README.md /home/carla/driver-aggressiveness-simulator/
COPY ./setup.py /home/carla/driver-aggressiveness-simulator/

# Copy the example notebook and make the folder writable
COPY ./example/ /home/carla/notebook
USER root
RUN chmod -R 777 /home/carla/notebook
USER carla

# Build and install the Python package "dasimulator"
WORKDIR /home/carla/driver-aggressiveness-simulator
RUN python setup.py bdist_wheel sdist
RUN python -m pip install -e .

# Set the working directory 
WORKDIR /home/carla

# Set the XDG_RUNTIME_DIR environment variable
ENV XDG_RUNTIME_DIR=/tmp/runtime-carla

# Expose the Jupyter Notebook port and Carla port
EXPOSE 8888 2000-2002

# Copy the entrypoint script
COPY ./entrypoint.sh /home/carla/entrypoint.sh
USER root
RUN chmod u+x /home/carla/entrypoint.sh
USER carla

# Run the entrypoint script
ENTRYPOINT [ "/home/carla/entrypoint.sh" ]
