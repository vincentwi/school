#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv)
{
  int nb_proc;
  int proc_nb;
  char mpi_hostname[MPI_MAX_PROCESSOR_NAME];
  int resultlen;
  int i;

  MPI_Init(&argc, &argv);

  MPI_Comm_size(MPI_COMM_WORLD, &nb_proc);
  MPI_Comm_rank(MPI_COMM_WORLD, &proc_nb);

  if (proc_nb == 0)
  {
    printf("Test MPI sur %d processus\n\n", nb_proc);
  }
  fflush(stdout);
  MPI_Barrier(MPI_COMM_WORLD);

  MPI_Get_processor_name(mpi_hostname, &resultlen);

  for (i=0; i<nb_proc; ++i)
  {
    if (proc_nb == i)
    {
      printf("Le processus de rang %3d s'execute sur %s\n ", i, mpi_hostname);
      MPI_Barrier(MPI_COMM_WORLD);
    }
  }

  MPI_Finalize();

  return 0;
}
