# CompArchProj2

Layth and Husam's version of project 2 

#4-2-21 
Took in the data, there was a major bug though at first. 
Problems with fopen (wasn't opening the file correctly) and 
syntax error with our bx lr that gave a seg fault. The major problem 
though was our handling of the FILE pointer from fopen, we figured out
at one point it was never opening and worked from there. We were using
fgets so the filename had a newline in it. We changed to scanf and
it worked. 

We also used fgets at first for each number, but that was also giving us
trouble, so we switched to using fscanf to read in the input.

#4-3-21
We found the error from taking in the data, and successfully read all the 
input in. We started the sort algo, basically we traversed through the array 
and found the minimum, and then loaded that into a sorted array and repeated the
process until all the items were loaded in. There was another major bug that kept us in
an infinite loop when sorting, and we figured out it was the register index that was 
changing somehow. We changed the register to use another and things worked smoothly. 

#4-4-21
We now wrote the sorted array to an outputfile taken in by the user. This went 
okay except for files with larger than 25 lines, it crashed. We saw our memory 
allocation was inaccurate, but that was a quick fix and it works for 100 lines. 
If the input file is larger than 100 lines, it sorts the first 100 lines only, 
but doesnt print an error or anything telling you. I think its fine for now (husam)


