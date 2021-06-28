/* Project 1  */
/* Read in two strings of max length 12 and concatenate them */ 
/* Ali Ghuman, Xue Ru Zhou, Husam Almanakly, Layth Yassin */ 

.global main 

.data 

.balign 4 
    input1: .asciz "Enter a string for a test: " 

.balign 4
    input2: .asciz "Enter a second string: "

.balign 4
    printf_msg: .asciz "You typed the words:\n%s\n" 

.balign 4
    errormsg: .asciz "Error: 12 Character Limit Exceeded\n"
    
.balign 1
    word_read: .skip 14
    
.balign 1
    word_read2: .skip 14
    
.balign 1
    concatenated: .skip 25

.balign 4
    return: .word 0

.balign 4
    newline: .asciz "\n"

.text

main: 
    //store the link register in addr_of_return
    ldr r1, addr_of_return    
    str lr, [r1]
    
   //set up counters and newline 
    mov r9, #0
    mov r7, #0
    ldr r6, addr_of_newline
    ldr r6, [r6]

    bl read_input 

read_input: 
    //prompt user with first message
    ldr r0, addr_of_input
    bl printf    
    //use c function fgets to read in input of length 14 
    ldr r0, addr_of_word_read
    mov r1, #14
    ldr r3, addr_of_stdin
    ldr r2, [r3] 
    bl fgets
    b loop1

read_input2: //read second input string  
    ldr r0, addr_of_input2
    bl printf    
    
    ldr r0, addr_of_word_read2
    mov r1, #14
    ldr r3, addr_of_stdin
    ldr r2, [r3] 
    bl fgets
    b loop2

loop1: //increments through the input string until new line and stores into array
    cmp r9, #13
    beq error
    ldr r1, addr_of_concat
    ldr r2, addr_of_word_read
    ldrb r5, [r2, r9]
    cmp r5, r6                //compare newline with value at the index r9 of r2
    beq read_input2
    strb r5, [r1, r9]  
    add r9, r9, #1
    b loop1

loop2: //stores values of second string using counter r7 and continues the concatenation
       //after the first string is stored using counter r9
    cmp r7, #13
    beq error2
    ldr r1, addr_of_concat
    ldr r2, addr_of_word_read2
    ldrb r5, [r2, r7]
    cmp r5, r6
    beq end 
    strb r5, [r1, r9]
    add r9, r9, #1
    add r7, r7, #1
    b loop2

end: //if the newline char is before the 14th element in the string array  
    ldr r0, addr_of_printf_msg
    bl printf

    mov r0, r9 
    ldr lr, addr_of_return
    ldr lr, [lr]
    bx lr

error: //if newline char is not in first 13 elements of string array 
    ldr r0, addr_of_errormsg
    bl printf

    mov r0, #7
    ldr lr, addr_of_return
    ldr lr, [lr]
    bx lr

error2: //if newline char is not in first 13 elements of string array
    ldr r0, addr_of_errormsg
    bl printf

    mov r0, #8
    ldr lr, addr_of_return
    ldr lr, [lr]
    bx lr
    
addr_of_printf_msg: .word printf_msg
addr_of_input: .word input1
addr_of_input2: .word input2
addr_of_word_read: .word word_read
addr_of_word_read2: .word word_read2
addr_of_concat: .word concatenated
addr_of_stdin: .word stdin
addr_of_return: .word return 
addr_of_newline: .word newline
addr_of_errormsg: .word errormsg

.global printf 
.global fgets 


