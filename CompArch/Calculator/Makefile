# Makefile

all: calc

calc: proj3.S .clean
	arm-linux-gnueabi-gcc $< -o $@ -ggdb3 -static -mfloat-abi=hard -mfpu=vfp -lm 

.clean: 
	rm -f calc
