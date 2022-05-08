import mpi4py.MPI as mpi
import sys

rank = mpi.COMM_WORLD.Get_rank()
size = mpi.COMM_WORLD.Get_size()
name = mpi.Get_processor_name()

sys.stdout.write("Hello, World! I am process %d of %d on %s.\n" %(rank, size, name))
