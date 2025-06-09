FROM ros:noetic-ros-base-buster

RUN sudo apt update && \
    sudo apt install libglfw3-dev python3-pip wget vim -y

# Install uv
RUN wget -qO- https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# setup zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -t jispwoso -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting && \
    chsh -s /bin/zsh
CMD [ "/bin/zsh" ]

# create workspace
RUN mkdir -p ~/ros_ws && \
    cd ~/ros_ws

# copy local files to the container
COPY . /root/ros_ws/src/ingrasp_manipulation/

WORKDIR /root/ros_ws

# install dependencies and some tools
RUN rosdep install -r --from-paths src --ignore-src --rosdistro $ROS_DISTRO -y
RUN uv sync --directory src/ingrasp_manipulation

# build
RUN . /opt/ros/$ROS_DISTRO/setup.sh && catkin_make

# setup .zshrc
RUN echo 'export TERM=xterm-256color\n\
source /opt/ros/noetic/setup.zsh'\
>> /root/.zshrc

# source entrypoint setup
RUN sed --in-place --expression \
      '$isource "/opt/ros/noetic/setup.bash"' \
      /ros_entrypoint.sh

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /root/ros_ws/src/ingrasp_manipulation