
.data 

.balign 4
    scan: .asciz "%c\n" //for reading in input

.balign 4
    lengthError: .asciz "ERROR: *Input length limit exceeded*\n" //error for later on i guess

.balign 4
    parError: .asciz "ERROR: *Parenthesis Syntax*\n"

.balign 1
    input: .skip 50 //used 50 here for now

.balign 8
    temp: .skip 1

.balign 8 
    postfix: .skip 152 // 19 is the max number of chars, including any possible decimal points

.balign 1
    idx: .skip 4 

.balign 4
    scanPattern: .asciz "%lf%n"

.balign 4
    null: .asciz "\0"

.balign 4
    printPattern: .asciz "%s\n" //for outputting

.balign 4
    return: .word 0 //used to save and retrieve lr 

.balign 4
    testPattern1: .asciz "%0.4lf\n"    

.balign 4
    testPattern2: .asciz "%d\n"

.balign 8
    operands: .skip 152

.balign 4
    firstMessage: .asciz "You entered the following expression: "

.text

.global main

main: 
    ldr r7, addr_of_return //set up lr for returning
    str lr, [r7]

    ldr r6, [r1, #4] //pointer to first char of argv into r6
    
    ldr r0, addr_of_printPattern //check to make sure what you're reading in 
    ldr r1, [r1, #4]
    bl printf

initialize_loop: //i separated this from main bc i overwrite r5 and r8
    ldr r10, addr_of_null //null to check for end of string
    ldr r10, [r10]
    mov r5, #0 //set up iterator to put into array
    ldr r8, addr_of_input

    b loop 
 
loop: //store into array 
    ldrb r9, [r6, r5]  //r9 = argv[r5]
    strb r9, [r8, r5]  //input[r5] = r9
    cmp r9, r10 //if null, end
    beq initialize_float  
    
    add r5, r5, #1 //update iterator
    b loop

//Converting from infix to postfix

initialize_float: 
    mov r4, #0 //r4 = n    
    mov r9, #0 

    ldr r6, addr_of_idx
    str r4, [r6]
    
    b float

float: 
    //still need ot check for starting with paranthesis
    cmp r4, r5 
    bge initialize_postfix 
    //bge initialize_check
    
    ldr r6, addr_of_input
    ldrb r6, [r6, r4]
    
    ldr r0, addr_of_input
    add r0, r0, r4
    ldr r1, addr_of_scanPattern
    ldr r2, addr_of_temp
    ldr r3, addr_of_idx
    bl sscanf
    
    cmp r6, #'+'
    beq load_op
    cmp r6, #'-'
    beq load_op
    cmp r6, #'/'
    beq load_op
    cmp r6, #'*'
    beq load_op
    cmp r6, #'('
    beq load_op
    cmp r6, #')'
    beq load_op
    cmp r6, #'^'
    beq load_op
    
    //load temp into operands 
    ldr r0, addr_of_operands
    add r0, r0, r9
    ldr r1, addr_of_temp
    ldmia r1, {r2-r3}
    stmia r0, {r2-r3}   
     
    ldr r6, addr_of_idx
    ldr r6, [r6]
    add r4, r4, r6 

    add r9, r9, #8

    b float

load_op:
    
    ldr r0, addr_of_operands
    ldr r1, addr_of_input
    ldrb r1, [r1, r4]
    str r1, [r0, r9]

    ldr r6, addr_of_idx
    ldr r6, [r6]
    add r4, r4, #1
    
    mov r10, #8
    mul r0, r6, r10
    add r9, r9, #8

    b float

//Block of code to print arrays

//initialize_check: 
//    mov r5, r9
//    mov r9, #0    
//
//    b check
//
//check:
//    cmp r9, r5
//    bge initialize_evaluate
//
//    ldr r6, addr_of_postfix
//    ldrb r6, [r6, r9]
//
//    cmp r6, #'+'
//    beq printc
//    cmp r6, #'-'
//    beq printc
//    cmp r6, #'/'
//    beq printc
//    cmp r6, #'*'
//    beq printc
//    cmp r6, #'('
//    beq printc
//    cmp r6, #')'
//    beq printc
//    cmp r6, #'^'
//    beq printc
//
//    //ldr r10, addr_of_operands
//    ldr r10, addr_of_postfix
//    add r10, r10, r9
//    ldmia r10, {r2-r3}
//    ldr r0, addr_of_testPattern1
//    bl printf
//    
//    vmov d0, r2, r3
//     
//
//
//    add r9, r9, #8
//
//    b check
//
//printc: 
//    mov r1, r6
//    ldr r0, addr_of_scan
//    bl printf
//    
//    add r9, r9, #8
//
//    b check

initialize_postfix:
    
    mov r11, r9
    
    mov r9, #0 //index of infix
    mov r4, #0 //index of postfix 
    mov r6, #0 // number of paranthesis

    ldr r8, addr_of_operands
        
    ldr r10, addr_of_null
    ldr r10, [r10]    
    push {r10}//push null onto stack as a marker for checking when the stack is empty 

    b read_exp 

read_exp:
    ldr r8, addr_of_operands
    add r8, r8, r9
    ldrb r5, [r8] //load the next element from infix
    
    cmp r11, r9
    beq empty_stack
    
    //check if char is a left parenthesis 
    cmp r5, #'('
    addeq r6, r6, #8
    beq left_parenthesis//branch to left_parenthesis if comparison is equal

    //check if char is a right parenthesis 
    cmp r5, #')' 
    addeq r6, r6, #8
    beq right_parenthesis//(right_parenthesis) 
    
    //check if char is a carrot (for exponent) 
    cmp r5, #'^' 
    pusheq {r5} //always push the carrot
    addeq r9, r9, #8
    beq read_exp 

    //check if char is "*" (for multiplication) 
    cmp r5, #'*' 
    beq mul_div

    //check if char is "/" ( division) 
    cmp r5, #'/' 
    beq mul_div //for "*" and "/", branch to mul_div (same precendence)
    
    //check if char is "+" (addition) 
    cmp r5, #'+' 
    beq add_sub
      
    //check if char is "-" (subtraction) 
    cmp r5, #'-'
    beq add_sub //addition and subtraction have the same precendence 
    
    ldr r8, addr_of_operands
    add r8, r8, r9
    ldr r2, addr_of_postfix 
    add r2, r2, r4
    vldr.f64 d0, [r8]
    vstr.f64 d0, [r2]
    
    add r4, r4, #8 
    add r9, r9, #8 

    b read_exp 

left_parenthesis: 
    add r9, r9, #8
    push {r5} //else, just push "(" to stack
    
    b read_exp

right_parenthesis: 
    //if stack is empty, a "(" is missing
    pop {r2} //load first element on stack into r2 without changing what's on the stack
    push {r2}	
    
    cmp r2, r10  //comparing to null char to check if stack is empty 
    beq err_missing_parenthesis 

    cmp r2, #'(' //discard "("
    popeq {r3} 
    addeq r9, r9, #8 
    beq read_exp

    pop {r3} //in other cases, pop the operators left in the stack
    ldr r2, addr_of_postfix
    strb r3, [r2, r4] 
    add r4, r4, #8
    
    b right_parenthesis //loop until you reach "("

mul_div: //push only if top of stack is "+", "-", "(" or stack is empty 
    pop {r2} 
    push {r2}
	
    add r9, r9, #8

    cmp r2, r10 
    pusheq {r5}
    beq read_exp 

    cmp r2, #'+' 
    pusheq {r5}
    beq read_exp 

    cmp r2, #'-' 
    pusheq {r5}
    beq read_exp 

    cmp r2, #'(' 
    pusheq {r5} 
    beq read_exp 

    pop {r3} 
    push {r5}
    
    ldr r2, addr_of_postfix
    strb r3, [r2, r4] 
    add r4, r4, #8 
    
    b read_exp 
 
add_sub: //push only if stack is empty or top of stack is "(" 
    pop {r2}
    push {r2} 	
    
    cmp r2, r10
    pusheq {r5}
    addeq r9, r9, #8
    beq read_exp 

    cmp r2, #'(' 
    pusheq {r5}
    addeq r9, r9, #8
    beq read_exp 

    pop {r3}
    ldr r2, addr_of_postfix 
    add r2, r2, r4
    strb r3, [r2] 
    add r4, r4, #8 
    
    b add_sub 

empty_stack: 
    pop {r5} //check if top of stack is null
    
    cmp r5, r10 
    subeq r9, r9, r6
    beq initialize_evaluate //branch to append_null if stack is empty 
    
    cmp r5, #'('
    beq err_missing_parenthesis
     
    ldr r2, addr_of_postfix
    strb r5, [r2, r4] //append operator to postfix, loop until stack is empty
    add r4, r4, #8 
    
    b empty_stack 

err_missing_parenthesis:
    ldr r0, addr_of_parError
    bl printf
   
    b end

initialize_evaluate:
    mov r11, r9

    mov r9, #0
    
    ldr r10, addr_of_null
    ldr r10, [r10]
    //push {r10}

    b evaluate

evaluate:
    cmp r9, r11
    beq end

    ldr r2, addr_of_postfix 
    ldrb r5, [r2, r9]

    //check if char is a carrot (for exponent) 
    cmp r5, #'^' 
    beq power 

    //check if char is "*" (for multiplication) 
    cmp r5, #'*' 
    beq multiply

    //check if char is "/" ( division) 
    cmp r5, #'/' 
    beq divide //for "*" and "/", branch to mul_div (same precendence)
    
    //check if char is "+" (addition) 
    cmp r5, #'+' 
    beq add
      
    //check if char is "-" (subtraction) 
    cmp r5, #'-'
    beq subtract //addition and subtraction have the same precendence 
     
    ldr r2, addr_of_postfix
    add r2, r2, r9
    vldr.f64 d0, [r2]
    vpush {d0}
    
    add r9, r9, #8
    b evaluate

power: 
    vpop {d1}  //might have gotten the order wrong
    vpop {d0}

    vmov r0, r1, d0
    vmov r2, r3, d1
    bl pow

    vmov d0, r0, r1
    vpush {d0}
    
    add r9, r9, #8

    b evaluate

multiply:
    vpop {d1}
    vpop {d2}
    vmul.f64 d0, d1, d2
    
    vpush {d0}
    
    add r9, r9, #8

    b evaluate 

divide: 
    vpop {d1}
    vpop {d2}
    vdiv.f64 d0, d2, d1
    
    vpush {d0}
    
    add r9, r9, #8

    b evaluate 

add: 
    vpop {d1}
    vpop {d2}
    vadd.f64 d0, d2, d1
    
    vpush {d0}
     
    add r9, r9, #8

    b evaluate 

subtract: 
    vpop {d1}
    vpop {d2}
    vsub.f64 d0, d2, d1
    
    vpush {d0}
    
    add r9, r9, #8

    b evaluate 
    

end:
    //might be a trailing zero or something
    vpop {d0}
    vmov r2, r3, d0
    ldr r0, addr_of_testPattern1
    bl printf

    mov r0, #0 //return 0 for success
    ldr lr, addr_of_return //retrieve lr
    ldr lr, [lr]
    bx lr


addr_of_printPattern: .word printPattern
addr_of_input: .word input
addr_of_postfix: .word postfix
addr_of_scan: .word scan
addr_of_null: .word null
addr_of_lengthError: .word lengthError
addr_of_parError: .word parError
addr_of_return: .word return
addr_of_idx: .word idx
addr_of_scanPattern: .word scanPattern
addr_of_testPattern1: .word testPattern1
addr_of_testPattern2: .word testPattern2
addr_of_operands: .word operands
addr_of_temp: .word temp
addr_of_firstMessage: .word firstMessage

.global printf
.global sscanf
.global pow
