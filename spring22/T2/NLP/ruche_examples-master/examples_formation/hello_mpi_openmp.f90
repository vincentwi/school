program mpi_openmp_test
  USE MPI
  USE omp_lib
  implicit none
  integer :: ierr, proc_id, nprocs
  integer :: level_mpi_provided
  integer :: thread_id, nthreads 

  call MPI_INIT_THREAD(MPI_THREAD_FUNNELED, level_mpi_provided, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD,nprocs,ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD,proc_id,ierr)
  if (level_mpi_provided < MPI_THREAD_FUNNELED) then
     if (proc_id == 0) print *, 'Error: level_mpi_provided < MPI_THREAD_FUNNELED'
     call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
  end if
!$omp parallel private( thread_id )
  thread_id = omp_get_thread_num()
  nthreads = omp_get_num_threads()
  write (*,'(a,i1,a,i2,a,i1,a,i1)') "Hello from thread ",thread_id," out of ",nthreads," from process ",proc_id," out of ",nprocs
!$omp end parallel
  call MPI_FINALIZE(ierr)
end program mpi_openmp_test
