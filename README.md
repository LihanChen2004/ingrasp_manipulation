# Robotic In-Hand Manipulation for Large-Range Precise Object Movement: The RGMC Champion Solution

[[Project Website](https://rgmc-xl-team.github.io/ingrasp_manipulation)]

Repository for the paper _Robotic In-Hand Manipulation for Large-Range Precise Object Movement: The RGMC Champion Solution_, IEEE Robotics and Automation Letters, 2024.

## 1. Overview

In this repository, we provide:

- The algorithm for our proposed in-grasp object movement approach.
- A simulator based on MuJoCo for a quick test of the algorithm.

We do not provide code related to the hardware implementation, as it depends on your specific hardware setup.

<div align="center">
  <img src="./docs/ingrasp_manipulation_simulation.gif" alt="MuJoCo simulation" width="50%" />
</div>

## 2. Quick Start

### 2.1 Setup Environment

- [Docker](https://docs.docker.com/engine/install/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- 允许本地的 Docker 容器访问主机的 X11 显示

    ```bash
    xhost +local:docker
    ```

### 2.2 Clone the project

```bash
mkdir -p ~/ros_ws && \
      cd ~/ros_ws && \
      git clone --recursive https://github.com/LihanChen2004/ingrasp_manipulation.git src/ingrasp_manipulation
```

### 2.3 Create Container

```bash
docker build -t ingrasp_manipulation ./src/ingrasp_manipulation
```

```bash
docker run -it --rm --name ingrasp_manipulation \
  --network host \
  --runtime nvidia \
  --gpus all \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e "DISPLAY=$DISPLAY" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev:/dev \
  -v $(pwd)/src:/root/ros_ws/src \
  ingrasp_manipulation
```

### 2.4 Usage (Simulation)

Run the mujoco simulation only (no motion):

```bash
# in your python env
cd src/ingrasp_manipulation/leap_task_A/scripts
source ../../../../devel/setup.zsh
uv run leaphand_mujoco.py
```

Run the in-grasp object movement:

```bash
# in your python env
cd src/ingrasp_manipulation/leap_task_A/scripts
source ../../../../devel/setup.zsh
uv run leaphand_control.py
```
