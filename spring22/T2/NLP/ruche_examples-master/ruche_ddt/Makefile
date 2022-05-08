### Determine compiler invocation ###

MPICXX=mpiicc

####### Definitions

objects = mmult.o
cflags = -g -std=c99 -O0
lflags = 
target = mmult

####### Implicit rules

.SUFFIXES: .c
.c.o:
	$(MPICXX) -c $(cflags) -o $@ $<

####### Target

.PHONY: all
all: $(target)

$(target): $(objects)
	$(MPICXX) $(cflags) -o $@ $^ $(lflags)

####### Objects

matrix_mult.o:

####### Clean

.PHONY: clean
clean:
	$(RM) $(target) core $(objects) *~
