#include <stdio.h>
#define N (2048 * 10000)
#define THREADS_PER_BLOCK 256     
#define num_t float

// The kernel - DOT PRODUCT
__global__ void dot(num_t *a, num_t *b, num_t *c) 
{
  __shared__ num_t temp[THREADS_PER_BLOCK];
  int index = threadIdx.x + blockIdx.x * blockDim.x;
  temp[threadIdx.x] = a[index] * b[index];
  //Synch threads
  __syncthreads();
  if (0 == threadIdx.x) {
    num_t sum = 0.00;
    int i;
    for (i=0; i<THREADS_PER_BLOCK; i++)
      sum += temp[i];
    atomicAdd(c, sum);        
  }
}


// Initialize the vectors:
void init_vector(num_t *x)
{
  int i;
  for (i=0 ; i<N ; i++){
    x[i] = i % 8 + 1;
  }
}

// MAIN
int main(void)
{
  num_t *a, *b, *c;
  num_t *dev_a, *dev_b, *dev_c;

  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  size_t size = N * sizeof(num_t);

  cudaMalloc((void**)&dev_a, size);
  cudaMalloc((void**)&dev_b, size);
  cudaMalloc((void**)&dev_c, size);

  num_t h_c = 0.0f;
  cudaMemcpy(dev_c, &h_c, sizeof(num_t), cudaMemcpyHostToDevice);

  a = (num_t*)malloc(size);
  b = (num_t*)malloc(size);
  c = (num_t*)malloc(size);

  init_vector(a);
  init_vector(b);

  cudaMemcpy(dev_a, a, size, cudaMemcpyHostToDevice);
  cudaMemcpy(dev_b, b, size, cudaMemcpyHostToDevice);

  cudaEventRecord(start);
  dot<<<N/THREADS_PER_BLOCK, THREADS_PER_BLOCK>>>(dev_a, dev_b, dev_c);
  cudaEventRecord(stop);

  cudaMemcpy(c, dev_c, sizeof(num_t), cudaMemcpyDeviceToHost);

  cudaEventSynchronize(stop); 
  float milliseconds = 0;
  cudaEventElapsedTime (&milliseconds, start, stop);
  //printf("Kernal Execution Time: %d\n", milliseconds);
  //printf("Effective Bandwidth (GB/s): %f", N*4*3/milliseconds/1e6);
  printf("Vector Size: %d\n", N);
  printf("Execution Time: %fms\n", milliseconds);
  printf("Inner Product: %f\n", *c);

  free(a); free(b); free(c);

  cudaFree(dev_a);
  cudaFree(dev_b);
  cudaFree(dev_c);

}
