# deep-learning-gpu-setup-linux
Full setup for a deep learning environment on Ubuntu Linux with CUDA, cuDNN, TensorRT, and TensorFlow GPU. Includes scripts, test code, and environment configuration

test_cudnn.c to test and verify that it is installed properly
gcc -o test_cudnn test_cudnn.c -I/usr/local/cuda-12.1/include -L/usr/local/cuda-12.1/lib64 -lcudnn
./test_cudnn
## to create an environment
conda env create -f environment.yml
conda activate tf
