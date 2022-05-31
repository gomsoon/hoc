CC=gcc
YFLAGS = -d			# force creation of y.tab.h

OBJS = hoc.o init.o math.o symbol.o		# abbreviation

hoc3:	$(OBJS)	
		gcc $(OBJS) -lm -o hoc3

hoc.o:	hoc.h
init.o symbol.o:	hoc.h y.tab.h
pr:
		@pr hoc.y hoc.h init.c math.c symbol.c makefile

clean:
		rm -f $(OBJS) y.tab.[ch]

