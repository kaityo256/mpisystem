all: a.out b.out

CC=mpic++
-include makefile.opt

a.out: a.cpp
	$(CC) $< -o $@

b.out: b.cpp
	$(CC) $< -o $@

.PHONY: clean
clean:
	rm -f a.out b.out
	
