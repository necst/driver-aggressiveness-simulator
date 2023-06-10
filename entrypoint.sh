#!/bin/bash

# Start Jupyter server
jupyter notebook --ip=0.0.0.0 --port=8888 --notebook-dir=/home/carla/notebook --no-browser --allow-root --certfile=/home/carla/mycert.pem --keyfile=/home/carla/mykey.key &

# Start CARLA server
/home/carla/CarlaUE4.sh -RenderOffScreen -noSound
