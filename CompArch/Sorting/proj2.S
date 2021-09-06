
.global main

.data

.balign 4
	input_msg: .asciz "Enter a file containing numbers: "
.balign 1
	file_name: .skip 25
.balign 4
	unsorted: .skip 404
.balign 4
	sorted: .skip 404
.balign 4
	output_msg: .asciz "Enter the name of the output file: "
.balign 1
	output_name: .skip 25
.balign 4
	error_msg_name: .asciz "Error: File name is too long\n"
.balign 4
	error_msg_long: .asciz "100 number limit exceeded. Only the first 100 numbers will be sorted.\n"
.balign 4
	return: .word 0
.balign 1
	mode: .asciz "r"
.balign 64
    file_pointer: .word 0
.balign 4
	temp_num: .word 0
.balign 4
    int_type: .asciz "%d"
.balign 4
    null: .asciz "\0"
.balign 4
	string_pattern: .asciz "%s"
.balign 4
    error_msg: .asciz "Error: Could not open inputted file name.\n"
.balign 4
    newline_int: .asciz "%d\n"
.balign 1
    mode_new: .asciz "a"
.balign 64
    output_pointer: .word 0

.text //IDK if we need this 

main:
	//store the link register in addr_of_return
	ldr r1, addr_of_return
    str lr, [r1]
	
    b read_input

read_input: // this branch reads the user input containing the file name of the unsorted numbers
    ldr r0, addr_of_input_msg
    bl printf
    
    ldr r0, addr_of_string_pattern
    ldr r1, addr_of_file_name
    bl scanf
    
    b file_open    

file_open:     	
    ldr r0, addr_of_file_name
    ldr r1, addr_of_mode
    bl fopen // the input file has been opened
		
    ldr r1, addr_of_null
    ldr r1, [r1]
    cmp r1, r0
    beq error_file // if the fopen function returns null, that means it did not open the file successfully, and it returns a null. We go to error_file branch if null is returned.

    ldr r2, addr_of_file_pointer
    str r0, [r2]

    mov r9, #0 // this serves as the index for traverse unsorted array
    ldr r5, addr_of_unsorted
    
    //mov r10, #0 // I dont think we need this, seems like something extra we had from previous tries

    b loop_read

loop_read:
    cmp r9, #400
    beq length_error // this condition checks if we have reached our pre-set limit of 100 numbers. If true, we stop reading in the input and move on as if we finished the file
    
    ldr r0, addr_of_file_pointer
    ldr r0, [r0]
    ldr r1, addr_of_int_type
    ldr r2, addr_of_temp_num
    bl fscanf // reads in the numbers from the file

    cmp r0, #1
    bne file_close // this checks if the file itself has ended. fscanf returns the number of successfully read stuff. Since we know we are reading in 1 number at a time,
		   // we say if the return value is not 1, we have reached the end of file. When this happens, we go to file_close branch cuz we are done with input file.

    ldr r0, addr_of_temp_num
    ldr r0, [r0]
    str r0, [r5, r9]
    add r9, r9, #4 // this block of code populates the unsorted array

    b loop_read // loops through, so reads in one number at a time and populates unsorted array one element at a time

length_error:
    ldr r0, addr_of_error_msg_long
    bl printf // just prints out the message saying that user input more than 100 numbers, so we are only sorting the first 100 numbers

    b file_close

file_close:
    ldr r0, addr_of_file_pointer
    ldr r0, [r0]
    bl fclose // closes the input file

	mov r8, #0 // look at my block of comments below (starting at line 164) to see the meaning of all the registers used for pretty much the rest of the code
	mov r5, #0
	
    b outer_loop

// EXPLANATION OF OUR Sorting ALGO
// we have the unsorted array which is just the user input. We traverse the array using index r8. The r8th element is said to be the 
// minimum initially. As we traverse the array, when we see something less than the initial minimum, we then call this smaller 
// number the new minimum. When we reach the end of the array, the number stored in the minimum (r6) is loaded into our sorted array
// into the leftmost open index. We also replace the number we just called the minimum with a null in the original unsorted array 
// so we don't count it again. We repeat this until we fully populate the sorted array, which will be the same length as the unsorted 
// array. To make sure u understand, you should realize that at the end of our algo, the unsorted array will consist of only nulls.

outer_loop:
	mov r10, #0
	mov r11, #0
	ldr r4, addr_of_unsorted
	ldr r6, [r4, r8] // loads the r8th element of the unsorted array into r6. We say that r6 is the minimum number in the unsorted array
			 // initially, but it will be updated as we traverse the array
    	
	ldr r1, addr_of_null
	ldr r1, [r1]
	cmp r6, r1 // here we check if r6 (the initial minimum) is a null (i.e., is this a real number or did we already sort this number)
	beq non_null // if it is a null, we go to non_null where we increment the index by 1 number (4 bytes). If this next number is still 
		     // null, then repeat until we get something non-null. 

	add r10, r8, #0 // we copy the value r8 to r10 here

	b sort

non_null: // this branch explained in lines 139-140
	add r8, r8, #4
	b outer_loop

load_minimum: // we come here to store the minimum into the leftmost available index in the sorted array
    cmp r5, r9
    beq output // we check if the sorted array has the same length as the unsorted array here. If it does, that means we're done sorting

    ldr r0, addr_of_sorted
    str r6, [r0, r5] // storing the minimum into sorted array
    ldr r1, addr_of_null
    ldr r1, [r1]
    str r1, [r4, r10] // replacing the number we just called minimum with a null in unsorted array

    add r5, r5, #4 // increment the index of the sorted array
      
    b outer_loop

// THIS IS THE BLOCK OF COMMENTS I WAS TALKING ABOUT. THIS IS VERY HELPFUL TO KEEP TRACK OF ALL THE INDEXES
// r0 is the address of the sorted array (in load_minimum)
// r4 is the address of the unsorted array
// r5 is the index of the sorted array
// r6 is the minimum
// r7 is the r11th element in unsorted array
// r8 is the index of the first non null
// r9 is the length of the unsorted array
// r10 index of the minimum
// r11 is the index of the unsorted array

sort:
	cmp r11, r9 // comparing the index of the unsorted array to the length of the unsorted array.
	beq load_minimum // if true, this means we have fully traversed the unsorted array, which means we have 
			 // the minimum number from whats left in the unsorted array. We go to load this minimum into the sorted array

	add r11, r11, #4 // increment the index of the unsorted array

	ldr r7, [r4, r11]
	ldr r1, addr_of_null
	ldr r1, [r1]
	cmp r7, r1
	beq sort // we check to see if the element in the r11th index is a number or a null. If it's null, we don't need to compare it
		 // with the minimum cuz it's not a number. We just go to the start of this branch to look at the next element in the unsorted 
		 // array. If it's a number, then we continue to the next comparison

	cmp r6, r7 // compare the current minimum to the r11th value in the unsorted array
	ble sort // if our current minimum is <= to the r11th value, then we go to the start of this branch and go on since we have the correct minimum
		 // so far. If it is not <=, then we go to the index branch. I will explain index branch in the branch itself

	b index

index:
	mov r6, r7 // we replace the old minimum with whatever is in r7 cuz that's the new minimum. So the new minimum is now in r6
	add r10, r11, #0 // we copy the index of the new minimum to r10, which always stores the index of the appropriate minimum. 
			 // We need to keep track of the index of the minimum so we can replace it with a null once we traverse the unsorted array
	b sort		 // we go back to sort to see if there is another number later in the unsorted array that could be the minimum

output: 
    ldr r0, addr_of_output_msg
    bl printf

    ldr r0, addr_of_string_pattern
    ldr r1, addr_of_output_name
    bl scanf
    
    ldr r0, addr_of_output_name
    ldr r1, addr_of_mode_new
    bl fopen
    
    ldr r2, addr_of_output_pointer
    str r0, [r2]
    
    mov r6, #0
    b write_output

write_output: // here we write the output to the output file
    cmp r6, r9
    beq exit

    ldr r0, addr_of_output_pointer
    ldr r0, [r0]
    ldr r1, addr_of_newline_int
    ldr r5, addr_of_sorted
    ldr r2, [r5, r6]
    bl fprintf
    
    add r6, r6, #4

    b write_output


error_file:
    ldr r0, addr_of_error_msg
    bl printf

    ldr lr, addr_of_return
    ldr lr, [lr]
    bx lr

exit: // just for debugging, leave for now
    ldr r0, addr_of_output_pointer
    ldr r0, [r0]
    bl fclose

	ldr lr, addr_of_return
    ldr lr, [lr]
    bx lr


addr_of_input_msg: .word input_msg
addr_of_file_name: .word file_name
addr_of_unsorted: .word unsorted
addr_of_sorted: .word sorted
addr_of_output_msg: .word output_msg
addr_of_output_name: .word output_name
addr_of_error_msg_name: .word error_msg_name
addr_of_error_msg_long: .word error_msg_long
addr_of_return: .word return
addr_of_stdin: .word stdin
addr_of_mode: .word mode
addr_of_temp_num: .word temp_num
addr_of_file_pointer: .word file_pointer
addr_of_int_type: .word int_type
addr_of_null: .word null
addr_of_string_pattern: .word string_pattern
addr_of_error_msg: .word error_msg
addr_of_newline_int: .word newline_int
addr_of_mode_new: .word mode_new
addr_of_output_pointer: .word output_pointer

.global fscanf 
.global fopen
.global fclose
.global scanf
.global printf

