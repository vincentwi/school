program main
  use mpi

  integer::error,id,p
!
!  Initialize MPI.
!
  call MPI_Init(error )
!
!  Get the number of processes.
!
  call MPI_Comm_size(MPI_COMM_WORLD,p,error)
!
!  Get the individual process ID.
!
  call MPI_Comm_rank(MPI_COMM_WORLD,id,error)
!
!  Print a message.
!
  if (id==0) then
    write(*,'(a,i1)') 'The number of MPI processes is ',p
  end if
!
!  Every MPI process will print this message.
!
  write ( *, '(a,i1)' ) 'Hello, world! from process ',id
!
!  Shut down MPI.
!
  call MPI_Finalize(error)
end program main
