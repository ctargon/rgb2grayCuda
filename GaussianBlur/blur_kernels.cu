#include "./gaussian_kernel.h" 
#include <math.h>

#define BLOCK_SIZE 32

/*
	The actual gaussian blur kernel to be implemented by 
	you. Keep in mind that the kernel operates on a 
	single channel.
 */
__global__ 
void gaussianBlur(unsigned char *d_in, unsigned char *d_out, 
					const int rows, const int cols, float *d_filter)
{

} 



/*
	Given an input RGBA image separate 
	that into appropriate rgba channels.
 */
__global__ 
void separateChannels(uchar4 *d_imrgba, const int numRows, const int numCols,
						unsigned char *d_r, unsigned char *d_g,
						unsigned char *d_b)
{
	int row = blockIdx.x * blockDim.x + threadIdx.x;
	int col = blockIdx.y * blockDim.y + threadIdx.y;

	if (row < numCols && col < numRows)
	{
		int idx = col * numCols + row;

		d_r[i] = d_imrgba[i].x;
		d_g[i] = d_imrgba[i].y;
		d_b[i] = d_imrgba[i].z;
	}
} 
 

/*
	Given input channels combine them 
	into a single uchar4 channel. 

	You can use some handy constructors provided by the 
	cuda library i.e. 
	make_int2(x, y) -> creates a vector of type int2 having x,y components 
	make_uchar4(x,y,z,255) -> creates a vector of uchar4 type x,y,z components 
	the last argument being the transperency value. 
 */
__global__ 
void recombineChannels(unsigned char *d_r, unsigned char *d_g, unsigned char *d_b, 
						uchar4 *d_orgba, const int numRows, const int numCows)
{
	int row = blockIdx.x * blockDim.x + threadIdx.x;
	int col = blockIdx.y * blockDim.y + threadIdx.y;

	if (row < numCols && col < numRows)
	{
		int idx = col * numCols + row;

		d_orgba[i] = make_uchar4(d_r[i], d_g[i], d_b[i], 255);
	}
} 


void your_gauss_blur(uchar4* d_imrgba, uchar4 *d_oimrgba, size_t rows, size_t cols, 
		unsigned char *d_red, unsigned char *d_green, unsigned char *d_blue, 
		unsigned char *d_rblurred, unsigned char *d_gblurred, unsigned char *d_bblurred,
		float *d_filter,  int filterWidth){
 
	dim3 blockSize(BLOCK_SIZE, BLOCK_SIZE, 1);
	dim3 gridSize(ceil(numCols / (float)BLOCK_SIZE), ceil(numRows / (float)BLOCK_SIZE), 1);

	separateChannels<<<gridSize, blockSize>>>(d_imrgba, d_red, d_green, d_blue); 
	cudaDeviceSynchronize();
	checkCudaErrors(cudaGetLastError());  

	gaussianBlur<<<gridSize, blockSize>>>(d_red, d_rblurred, rows, cols, d_filter); 
	cudaDeviceSynchronize();
	checkCudaErrors(cudaGetLastError());  

	gaussianBlur<<<gridSize, blockSize>>>(d_green, d_gblurred, rows, cols, d_filter);  
	cudaDeviceSynchronize();
	checkCudaErrors(cudaGetLastError());  

	gaussianBlur<<<gridSize, blockSize>>>(d_blue, d_bblurred, rows, cols, d_filter); 
	cudaDeviceSynchronize();
	checkCudaErrors(cudaGetLastError());   

	recombineChannels<<<gridSize, blockSize>>>(d_rblurred, d_gblurred, d_bblurred, d_oimrgba); 

	cudaDeviceSynchronize();
	checkCudaErrors(cudaGetLastError());   

}




