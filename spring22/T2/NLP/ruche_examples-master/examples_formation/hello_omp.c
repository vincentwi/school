# include <stdlib.h>
# include <stdio.h>
# include <omp.h>

int main ( int argc, char *argv[] );

/******************************************************************************/

int main ( int argc, char *argv[] )
{
  int id;

  printf ("Number of processors available = %d\n",omp_get_num_procs());
  printf ("Number of threads =              %d\n",omp_get_max_threads());

#pragma omp parallel private(id)
  {
    id = omp_get_thread_num();
    printf ("Hello from process %d\n",id);
  }
  return 0;
}
