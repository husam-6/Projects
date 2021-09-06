# Makefile

all: a.out

a.out: proj1.S .clean
	arm-linux-gnueabi-gcc $< -o $@ -ggdb3 -static   

.clean: 
	rm -f a.out
