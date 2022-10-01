#include<stdio.h>
#include<iostream>
using namespace std;
        /* a sum reduction on the array of floats 'in'.
         * The reduction result is written to the
          * address 'result'.  The number of elements to
           * be reduced is given by 'size'
            *
             * The example contains data races because barrier
              * synchronisation statements, of the form:
               *   __syncthreads();
                * are missing.
                 *
                  * Can you add them to eliminate all data races?
                   */

#define N 2 /* Same as blockDim */

#define tid threadIdx.x

__global__ void reduce(int *in, int *result, int size) {

      __shared__ int partial_sums[N];

        /* Each thread sums elements
             in[tid], in[tid + N], in[tid + 2*N], ...
               */
                 partial_sums[tid] = in[tid];
                   for(int i = tid + N; i < size; i += N) {
                           partial_sums[i] += in[i];
                             }

                               /* Tree reduction computes final sum into partial_sums[0] */
                                 for(int d = N/2; d > 0; d >>= 1) {
                                         if(tid < d) {
                                                   partial_sums[tid] += partial_sums[tid + d];
                                                       }
                                                         }

                                                           /* Master thread writes out result */
                                                             if(tid == 0) {
                                                                     *result = partial_sums[0];
                                                                       }
                                                                         
}

const int threadsPerBlock = N;
int main(){
    int* A, *devA, *B, *devB;
    int size = 8192;
    A = new int[N];
    B = new int;
    cudaMalloc((void **) &devA, sizeof(int) * N);
    cudaMalloc((void **) &devB, sizeof(int));
    cudaMallov
    for (int i = 0; i < N; i++)
        A[i] = i;
    cudaMemcpy(devA, A, N * sizeof(int), cudaMemcpyHostToDevice);
    reduce<<<1, threadsPerBlock>>>(devA, devB);
    cudaMemcpy(A, devA, N * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy(B, devB, N * sizeof(int), cudaMemcpyDeviceToHost);
    return 1;
}
