##// test_cudnn.c..,..
#include <cudnn.h>
#include <stdio.h>

int main() {
    cudnnHandle_t handle;
    cudnnStatus_t status = cudnnCreate(&handle);

    if (status == CUDNN_STATUS_SUCCESS) {
        printf("✅ cuDNN initialized successfully.\n");
    } else {
        printf("❌ cuDNN initialization failed.\n");
    }

    cudnnDestroy(handle);
    return 0;
}
