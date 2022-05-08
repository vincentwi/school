#Makefile

FC = mpiifort -qopenmp
LD = mpiifort -qopenmp

SRC = $(wildcard *.f90)
OBJ = $(SRC:.f90=.o)
EXE = $(SRC:.f90=)

all: $(EXE)

$(EXE): $(OBJ)
	$(LD) $^ -o $@

%.o: %.f90
	$(FC) -c $< -o $@

clean:
	rm -f $(EXE) $(OBJ)
