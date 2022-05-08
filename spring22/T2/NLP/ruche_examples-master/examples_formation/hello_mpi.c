# include <stdlib.h>
# include <stdio.h>
# include <time.h>

# include "mpi.h"

int main ( int argc, char *argv[] );

/******************************************************************************/

int main ( int argc, char *argv[] )
{
  int id;
  int ierr;
  int p;
/*
  Initialize MPI.
*/
  ierr = MPI_Init(&argc,&argv);
/*
  Get the number of processes.
*/
  ierr = MPI_Comm_size(MPI_COMM_WORLD, &p);
/*
  Get the individual process ID.
*/
  ierr = MPI_Comm_rank(MPI_COMM_WORLD, &id);
/*
  Process 0 prints an introductory message.
*/
  if (id==0) 
  {
    printf("The number of processes is %d.\n", p);
  }
/*
  Every process prints a hello.
*/
  printf("Hello, world! from process %d\n", id);
/*
  Terminate MPI.
*/
  ierr = MPI_Finalize();

  return 0;
}
