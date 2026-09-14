// palinfinder.s, provided with Lab1 in TDT4258 autumn 2026
.global _start
// Please keep the _start method and the input strings name ("input") as
// specified below
// For the rest, you are free to add and remove functions as you like,
// just make sure your code is clear, concise and well documented.
_start:
// Here your execution starts
  b check_input
check_input:
// You could use this symbol to check for your input length
// you can assume that your input string is at least 2 characters
// long and ends with a null byte
    // r0 = pointer to input string
    // r1 = length counter
    ldr r0, =input      // load address of input string into r0
    mov r1, #0           // initialize length counter to 0
	
count_loop:
    ldrb r2, [r0, r1]    // load byte at input[r1] into r2
    cmp r2, #0           // is it the null terminator?
    beq count_done       // null terminator means we are done counting
    add r1, r1, #1       // increment counter
    b count_loop         // loop
	
	
	count_done:
    cmp r1, #4
    blt is_no_palindrom  // If length < 4
	
check_palindrom:
    mov r3, #0           // i = 0
    sub r4, r1, #1       // j = length - 1

compare_loop:
    cmp r3, r4
    bge is_palindrom     // i and j met/crossed

skip_spaces_left:
    ldrb r5, [r0, r3] // r5 = input[i]
    cmp r5, #' ' // Check if r5 is a space
    bne skip_spaces_right // Not a space
    add r3, r3, #1 // its a space, so skip it
    cmp r3, r4           // re-check crossing after moving i
    bge is_palindrom
    b skip_spaces_left // check if there are more spaces

skip_spaces_right:
    ldrb r6, [r0, r4] // r6 = input[j]
    cmp r6, #' '
    bne wildcard // Not a space, check for wildcards
    sub r4, r4, #1 //its a space, so skip one
    cmp r3, r4           // re-check crossing after moving j
    bge is_palindrom
    b skip_spaces_right // check if there are more spaces


    // wildcard check: '?' or '%' on either side matches anything (except space)
wildcard:
    cmp r5, #'?'
    beq chars_match
    cmp r5, #'%'
    beq chars_match
    cmp r6, #'?'
    beq chars_match
    cmp r6, #'%'
    beq chars_match

    // if uppercase (A-Z), convert to lowercase
    cmp r5, #'A'
    blt skip_lower_r5
    cmp r5, #'Z'
    bgt skip_lower_r5
    add r5, r5, #32
skip_lower_r5:

    cmp r6, #'A'
    blt skip_lower_r6
    cmp r6, #'Z'
    bgt skip_lower_r6
    add r6, r6, #32
skip_lower_r6:

 // no spaces, no wildcards, all lowercase, let's finally compare the two characters
    cmp r5, r6 
    bne is_no_palindrom // mismatch!!

chars_match: // characters match, increment positions and redo loop
    add r3, r3, #1       // i++
    sub r4, r4, #1       // j--
    b compare_loop
	
	
	
is_palindrom:
    ldr r7, =0xFF200000   // LED base address
    mov r8, #0x1F         // LED0-LED4
    str r8, [r7]          // write pattern to LED register
    ldr r0, =detected      // load address of success string
    b print_string        // call UART print routine


is_no_palindrom:
    ldr r7, =0xFF200000   // LED base address
    mov r8, #0x3E0        // LED5-LED9
    str r8, [r7]          // write pattern to LED register
    ldr r0, =mismatch         // load address of failure string
    b print_string        // call UART print routine
	

	
	print_string:
    ldr r9, =0xFF201000      // JTAG UART base address


	
print_loop:
    ldrb r10, [r0]          // Load next character
    cmp r10, #0             // Check for null terminator
    beq _exit          // If null, exit


    str r10, [r9]           // Write character to UART data register
    add r0, r0, #1          // Advance string pointer
    b print_loop


_exit:
// Branch here for exit
b .
.data
.align
// This is the input you are supposed to check for a palindrom
// You can modify the string during development, however you
// are not allowed to change the name 'input'!
input: .asciz "Grav ned den varg"

//input: .asciz "level"
//input: .asciz "abc?dc%a"
//input: .asciz "8448"
//input: .asciz "step on no pets"
//input: .asciz "My gym"
//input: .asciz "Was it a car or a cat I saw"
//input: .asciz "Palindrome"
//input: .asciz "First level"
//input: .asciz "KayAk"
//input: .asciz "A9c9a"


detected: .asciz "Palindrome detected "
mismatch: .asciz "Not a palindrome "
.end


	
	
	
	
	
	