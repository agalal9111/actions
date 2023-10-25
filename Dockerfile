FROM nvidia/cuda:12.2.2-base-ubuntu22.04
ENV DEBIAN_FRONTEND noninteractive
# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    cmake \
    libffi-dev \
    libssl-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libopencv-dev \
    python3-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /mmdetection
# Clone MMDetection repository
RUN git clone -b v3.2.0 https://github.com/open-mmlab/mmdetection.git .

# Install Python dependencies
COPY requirements/build.txt requirements/build.txt
RUN pip3 install --no-cache-dir -r requirements/build.txt

COPY requirements/optional.txt requirements/optional.txt
RUN pip3 install --no-cache-dir -r requirements/optional.txt

#COPY requirements/runtime.txt requirements/runtime.txt
#RUN pip3 install --no-cache-dir -r requirements/runtime.txt

# Build MMDetection
RUN python3 setup.py install

# Set environment variables if needed
# ENV CUDA_VISIBLE_DEVICES=0

# Set the default command to run when a container is started
CMD ["bash"]
