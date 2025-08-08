
# Copyright (C) 2025 ibrar-syed <syed.ibraras@gmail.com>
# This file is part of the GUI.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#!/bin/bash
#........
# ====================================
# Deep Learning Environment Setup on Linux
# CUDA, cuDNN, TensorRT, Python, TensorFlow
# Author: Your Name
# ====================================

echo " Updating system packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential -y

echo " Installing Miniconda..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# ==========================
# CUDA Toolkit Installation
# ==========================

echo " Installing CUDA 12.1.1..."
wget https://developer.download.nvidia.com/compute/cuda/12.1.1/local_installers/cuda_12.1.1_530.30.02_linux.run
sudo sh cuda_12.1.1_530.30.02_linux.run

echo " Updating environment variables..."
echo 'export PATH=/usr/local/cuda-12.1/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.1/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

sudo ldconfig
nvcc --version

# ==========================
# cuDNN Installation
# ==========================

echo " Setting up cuDNN..."
# Replace with actual download of cuDNN archive from:
# https://developer.nvidia.com/rdp/cudnn-archive

tar -xf cudnn-linux-x86_64-8.9.7.29_cuda12-archive.tar.xz
cd cudnn-linux-x86_64-8.9.7.29_cuda12-archive

sudo cp include/cudnn*.h /usr/local/cuda-12.1/include
sudo cp lib/libcudnn* /usr/local/cuda-12.1/lib64
sudo chmod a+r /usr/local/cuda-12.1/include/cudnn*.h /usr/local/cuda-12.1/lib64/libcudnn*

cd ..

# ==========================
# Optional cuDNN Test
# ==========================

echo " Testing cuDNN installation..."
cat << EOF > test_cudnn.c
#include <cudnn.h>
#include <stdio.h>
int main() {
    cudnnHandle_t handle;
    if (cudnnCreate(&handle) == CUDNN_STATUS_SUCCESS)
        printf("cuDNN initialized successfully.\n");
    else
        printf("cuDNN failed to initialize.\n");
    cudnnDestroy(handle);
    return 0;
}
EOF

gcc -o test_cudnn test_cudnn.c -I/usr/local/cuda-12.1/include -L/usr/local/cuda-12.1/lib64 -lcudnn
./test_cudnn

# ==========================
# TensorRT Installation
# ==========================

echo " Installing TensorRT..."
# Download manually: https://developer.nvidia.com/tensorrt/download

tar -xzvf TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-12.0.tar.gz
sudo mv TensorRT-8.6.1.6 /usr/local/TensorRT-8.6.1

echo "🔧 Configuring environment for TensorRT..."
echo 'export PATH=/usr/local/TensorRT-8.6.1/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/TensorRT-8.6.1/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

sudo ldconfig

# ==========================
# Python + TensorFlow Setup
# ==========================

echo " Creating Conda environment with Python 3.9..."
conda create --name tf python=3.9 -y
conda activate tf

echo " Installing TensorFlow with CUDA support..."
pip install tensorflow[and-cuda]

python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"

# ==========================
# TensorRT Python Bindings
# ==========================

cd /usr/local/TensorRT-8.6.1/python
pip install tensorrt-8.6.1-cp39-none-linux_x86_64.whl
pip install tensorrt_dispatch-8.6.1-cp39-none-linux_x86_64.whl
pip install tensorrt_lean-8.6.1-cp39-none-linux_x86_64.whl

# ==========================
# Jupyter Setup
# ==========================

echo " Installing JupyterLab for experimentation..."
pip install jupyterlab
jupyter lab

echo " Setup complete."
nvidia-smi
