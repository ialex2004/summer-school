#pragma OPENCL EXTENSION cl_khr_fp64 : enable
//******************************************
// operators.f90
// based on min-app code written by Oliver Fuhrer, MeteoSwiss
// modified by Ben Cumming, CSCS
// modified by Aleksei Ivakhnenko, APC LLC
// *****************************************

// Description: Contains simple operators which can be used on 3d-meshes

#define U(j,i)    x_new[(i) + (j)*nx]
#define S(j,i)    b[(i) + (j)*nx]
#define X(j,i)    x_old[(i) + (j)*nx]


#define bndN(j)		bnd[j]
#define bndS(j)		bnd[nx+j]
#define bndW(j)		bnd[2*nx+j]
#define bndE(j)		bnd[2*nx+ny+j]

__kernel void cl_diffusion_center(__global double* x_new, __global double * b, __global double * x_old, __global double * bnd, __private int nx, __private int ny, __private double dxs, __private double alpha)
{
    //struct discretization_t* options = options;

    //double (*u)[options.nx] = (double(*)[options.nx])up;
    //double (*s)[options.nx] = (double(*)[options.nx])sp;

    //double (*x_old)[options.nx] = (double(*)[options.nx])x_old;
    //double *bndE = bndE, *bndW = bndW;
    //double *bndN = bndN, *bndS = bndS;

    
    //int    iend  = options.nx - 1;
    //int    jend  = options.ny - 1;

    
	int global_x=get_global_id(0);
	int global_y=get_global_id(1);
	
	int i=global_x+1;
	int j=global_y+1;
	
    // the interior grid points
    
	if ((i>0)&&(i<nx-1)&&(j>0)&&(j<ny-1))
		{
            S(j, i) = -(4. + alpha)*U(j,i)               // central point
                                    + U(j,i-1) + U(j,i+1) // east and west
                                    + U(j-1,i) + U(j+1,i) // north and south

                                    + alpha*X(j,i)
                                    + dxs*U(j,i)*(1.0 - U(j,i));
									
        }
		// the east boundary
}

