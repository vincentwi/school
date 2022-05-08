#Makfile

CC = mpicc
LD = mpicc

SRC = $(wildcard *.c)
OBJ = $(SRC:.c=.o)
EXE = $(SRC:.c=)

all: $(EXE)

$(EXE): $(OBJ)
	$(LD) $^ -o $@

%.o: %.c
	$(CC) -c $< -o $@

clean:
	rm -f $(EXE) $(OBJ)
