############################ -*- Mode: Makefile -*- ###########################
## Makefile --- 
## 
## Auteur          : Pierre-François LAVALLEE (CNRS/IDRIS) <lavallee@idris.fr>
## Créé le         : Tue Oct  7 10:54:47 2003
## Dern. mod. par  : Pierre-François LAVALLEE (CNRS/IDRIS) <lavallee@idris.fr>
## Dern. mod. le   : Tue Jul 13 09:46:49 2010
###############################################################################

F90 = ifort
LDFLAGS = -O3 -xHost -g
FFLAGS = -fpp -O3 -xHost -g

# Sources directories
#--------------------
SRCDIR = .

# Objects
#------------
OBJ = module_hydro_commun.o module_hydro_IO.o module_hydro_utils.o module_hydro_principal.o main.o

hydro:  $(OBJ)
	$(F90) $(LDFLAGS) $(OBJ) -o hydro 

clean:
	rm -f *.o *.mod 

cleanall:
	rm -f *.o *.mod hydro

%.o:    $(SRCDIR)/%.f90
	$(F90) $(FFLAGS) -c $<

# Dependencies
#-------------
main.o : main.f90 module_hydro_principal.o module_hydro_IO.o module_hydro_commun.o
module_hydro_commun.o : module_hydro_commun.f90
module_hydro_IO.o : module_hydro_IO.f90 module_hydro_commun.o
module_hydro_principal.o : module_hydro_principal.f90 module_hydro_commun.o module_hydro_utils.o
module_hydro_utils.o : module_hydro_utils.f90 module_hydro_commun.o
