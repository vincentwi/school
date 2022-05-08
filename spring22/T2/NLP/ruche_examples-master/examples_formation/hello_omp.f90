program main

  use omp_lib

  implicit none

  integer:: id

  write ( *, '(a,i8)' ) &
    'The number of processors available = ', omp_get_num_procs()
  write ( *, '(a,i8)' ) &
    'The number of threads available    = ', omp_get_max_threads()

!$omp parallel private ( id )
  id = omp_get_thread_num()
  write ( *, '(a,i8,a,i8)' ) 'HELLO from process ', id
!$omp end parallel

end program main
