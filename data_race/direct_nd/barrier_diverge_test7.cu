#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <cuda.h>

using namespace std;
#define imin(a,b) (a<b?a:b)

const int N = 4;
const int threadsPerBlock = 4;
const int blocksPerGrid = 1;

__global__ void dot(int *a) {
//int gid = threadIdx.x + blockIdx.x * blockDim.x; 
//int i = a[gid];
//int j = b[gid];
//int k = i + j;
    int tid = threadIdx.x;
    if ((tid % 2) == 1){
        int t0 = a[tid - 1];
        int t1 = a[tid];
        a[tid] = t0+t1;

    } else {
        int t0 = a[tid + 1];
        int t1 = a[tid];
        a[tid] = t0 + t1;
 
    }
//    else
//        c[gid] =  1;
//    c[gid] = c[gid] + 1;
}
//__global__ void dot2(int *a, int *b, int*c) {
//int gid = threadIdx.x + blockIdx.x * blockDim.x;
//int i = a[gid];
//int j = b[gid];
//int k = i + j;
//}
//__global__ void mykernel(int *data){
//    atomicAdd(data, 10); 
//}
   
int main(){
    int *a;
    int *dev_a;
    
    a = new int[N];
    for (int i = 0; i < N; i++) {
        a[i] = i;
    }
    cudaMalloc((void **)&dev_a, sizeof(int) * N);
    cudaMemcpy(dev_a, a, N*sizeof(int), cudaMemcpyHostToDevice);
    dot<<<blocksPerGrid, threadsPerBlock>>>(dev_a);
    cudaMemcpy( a, dev_a, N*sizeof(int), cudaMemcpyDeviceToHost);
    #define sum_sq(x) (x*(x+1)*(2*x+1)/6)

    for (int i = 0;i < N; i++)
        printf("%d\n", a[i]);
    cudaFree(dev_a);
    

    delete[]  a;
}
