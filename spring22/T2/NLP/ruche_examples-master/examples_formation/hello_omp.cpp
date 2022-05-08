# include <cstdlib>
# include <iostream>
# include <iomanip>
# include <omp.h>

using namespace std;

int main ( int argc, char *argv[] );

//****************************************************************************

int main ( int argc, char *argv[] )
{
  int id;

  cout << "Number of processors available = " << omp_get_num_procs() << "\n";
  cout << "Number of threads =              " << omp_get_max_threads() << "\n";


# pragma omp parallel private (id)
  {
    id = omp_get_thread_num();
    cout << "Hello from processThis is process " << id << "\n";
  }
  return 0;
}
