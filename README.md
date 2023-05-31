# DASimulator

---

This tool exploits [CARLA simulator](https://carla.org/) to allow user simulate the behavior of an **aggressive driver** given the level of aggressiveness. The aggressiveness level decided by the user is consistent with the aggressiveness index defined in [B. Shi *et al*., "Evaluating Driving Styles by Normalizing Driving Behavior Based on Personalized Driver Modeling," in *IEEE Transactions on Systems, Man, and Cybernetics: Systems*, vol. 45, no. 12, pp. 1502-1508, Dec. 2015, doi: 10.1109/TSMC.2015.2417837](https://ieeexplore.ieee.org/document/7090994), which has been taken as reference.

DASimulator makes use of a modified version of CARLA agents, which represents a driver using two PID controllers (one for longitudinal control, one for lateral). Specifically, a link has been found between the PID’s $k_p$ (proportional) and $k_d$ (derivative) parameters, and the computed value of the proposed aggressiveness index, evaluated over the standard FTP-75 driving cycle.

DASimulator allows the end users to provide a `carla.World` object, a `carla.Vehicle`, specify a route to be followed, an optional speed profile and obviously the target aggressiveness index of the driver. The simulator will run and generate on a given file the signals retrieved during simulation, including throttle, brake, real speed profile and data collected by an IMU mounted on the vehicle (acceleration and angular velocity).

# Installation

---

Before starting check out the [system requirements](https://carla.readthedocs.io/en/0.9.14/start_quickstart/#:~:text=System%20requirements.,GB%20of%20space.) on CARLA docs.

Use `git clone` or download the project from this page:

```bash
git clone https://github.com/necst/driver-aggressiveness-simulator.git
```

The whole project, including both the modified version of CARLA’s agents and the developed `dasimulator` Python module, have been wrapped in a Docker image. This will allow to run CARLA in a container and interact with the simulation thanks to a jupyter server.

Before starting to build the Docker image, follow the [instructions](https://carla.readthedocs.io/en/0.9.14/build_docker/#before-you-begin) to install everything is needed to run CARLA in a container. Now you can procede to **build the image**:

```bash
docker build -t das_image.
```

Once the image has been built, you can procede to **run DASimulator in a container**:

```bash
docker run --privileged --gpus all --net=host -v /tmp/.X11-unix:/tmp/.X11-unix:rw -p 8888:8888 das_image bash -c "jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --certfile=/home/carla/mycert.pem --keyfile=/home/carla/mykey.key & ./CarlaUE4.sh -RenderOffScreen -noSound"
```

The simulator will start running as well as Jupyter Notebook. You’ll be able to reach the jupyter server by following the URL in the output of the terminal which will look like this:

```bash
[I HH:MM:SS NotebookApp] Jupyter Notebook 6.5.4 is running at:
[I HH:MM:SS NotebookApp] <URL-TO-JUPYTER>
[I HH:MM:SS NotebookApp]  or <https://127.0.0.1:8888/TOKEN>
```

In Jupyter Home Page you’ll be able to see an /example folder that contains the example.ipynb notebook to understand how to use `dasimulator` python module.
