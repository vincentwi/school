#include <stdio.h>
#include <mpi.h>
#include <omp.h>

int main(int argc, char *argv[]) {
  int numprocs, rank;
  int iam, np;
  int level_mpi_provided;

  MPI_Init_thread(&argc, &argv, MPI_THREAD_FUNNELED, &level_mpi_provided);
  MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  if (level_mpi_provided < MPI_THREAD_FUNNELED)
  {
    if (rank == 0)
      printf("Error: level_mpi_provided < MPI_THREAD_FUNNELED\n");

    MPI_Abort(MPI_COMM_WORLD, 1);
  }

#pragma omp parallel default(shared) private(iam, np)
  {
    np = omp_get_num_threads();
    iam = omp_get_thread_num();
    printf("Hello from thread %d out of %d from process %d out of %d\n",
           iam, np, rank, numprocs);
  }

  MPI_Finalize();
}
