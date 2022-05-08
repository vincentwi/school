# include <cstdlib>
# include <ctime>
# include <iomanip>
# include <iostream>
# include <mpi.h>

using namespace std;

int main ( int argc, char *argv[] );

//****************************************************************************

int main ( int argc, char *argv[] )
{
  int id;
  int ierr;
  int p;
//
//  Initialize MPI.
//
  ierr = MPI_Init(&argc,&argv);
//
//  Get the number of processes.
//
  ierr = MPI_Comm_size(MPI_COMM_WORLD, &p);
//
//  Get the individual process ID.
//
  ierr = MPI_Comm_rank(MPI_COMM_WORLD, &id);
//
//  Process 0 prints an introductory message.
//
  if ( id == 0 ) 
  {
    cout << "The number of processes is " << p << "\n";
  }
//
//  Every process prints a hello.
//
  cout << "Hello, world! from process " << id << "\n";
//
//  Terminate MPI.
//
  MPI_Finalize();

  return 0;
}
