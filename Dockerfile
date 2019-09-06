FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu16.04
# https://github.com/rubenrtorrado/GVGAI_GYM.git

#PYTHON
RUN apt update \
  && apt install -y software-properties-common \
  && add-apt-repository ppa:jonathonf/python-3.6 \
  && apt update \
  && apt install -y python3.6 \
  && apt install -y python3.6-dev \
  && apt install -y python3.6-venv \
  && apt install -y wget \
  && wget https://bootstrap.pypa.io/get-pip.py \
  && python3.6 get-pip.py \
  && ln -s /usr/bin/python3.6 python \
  && ln -s /usr/local/bin/pip pip3 \
  && pip3 install --upgrade pip

# NUMPY/SCIPY
RUN apt install -y unzip git \
  && pip3 install --no-input numpy \
  && pip3 install --no-input scipy

#PYTORCH
RUN pip3 install https://download.pytorch.org/whl/cu100/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl \
  && pip3 install torchvision

#AWS
RUN apt install -y zip \
  && pip3 install --no-input awscli \
  && pip3 install  --no-input awscli-plugin-endpoint

#GYM
RUN pip3 install --no-input gym==0.10.5 \
  && apt install -y swig \
  && pip3 install --no-input box2d

#PYGAME
RUN pip3 install --no-input pygame

#ATARI
RUN apt install -y cmake \
  && apt install -y zlib1g-dev \
  && pip3 install --no-input gym[atari]

#NEAT-PYTHON
RUN pip3 install --no-input neat-python
  
#display stuff
RUN pip3 install --no-input jupyter \
  && pip3 install --no-input pillow \
  && apt install -y x11vnc xvfb fluxbox wmctrl \
  && pip3 install --no-input matplotlib \
  && apt install -y python3-tk \
  && apt install -y python-opengl \
  && apt install -y vim
 
CMD mkdir /root/code/notebooks
WORKDIR /root/code

#GVGAI
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
RUN apt install -y openjdk-9-jdk-headless \
  && git clone https://github.com/rubenrtorrado/GVGAI_GYM.git \
  && cd GVGAI_GYM \
  && pip install -e .

#ECJ
RUN wget https://cs.gmu.edu/~eclab/projects/ecj/ecj26.tar.gz \
  && tar -xzf ecj26.tar.gz \
  && cd ecj \
  && apt install -y maven \
  && mvn clean package -B
  
#ports
EXPOSE  8888
EXPOSE  6006
EXPOSE  5901
ENV DISPLAY=:1
COPY run.sh /
COPY disp_funcs.sh /
CMD ["/run.sh", "--allow-root"]
