.global main
.func main


main:
LDR R10, =start_message         @ load addr of prompt string for impending printf call
BL printf
MOV R0, #0                    @ initialze index

writeloop:
CMP R0, #10            @ check to see if we are done iterating
BEQ writedone           @ exit loop if done
LDR R1, =a              @ get address of a
LSL R2, R0, #2          @ multiply index*4 to get array offset
ADD R2, R1, R2          @ R2 now has the element address
PUSH {R0}               @ backup iterator before procedure call
PUSH {R2}               @ backup element address before procedure call
BL _scanf             @ get a random number
POP {R2}                @ restore element address
STR R0, [R2]            @ write the address of a[i] to a[i]
POP {R0}                @ restore iterator
ADD R0, R0, #1          @ increment index
B   writeloop           @ branch to next loop iteration

writedone:
MOV R0, #0              @ initialze index variable

_scanf:
PUSH {LR}                @ store LR since scanf call overwrites
SUB SP, SP, #4          @ make room on stack
LDR R0, =format_str     @ R0 contains address of format string
MOV R1, SP              @ move SP to R1 to store entry on stack
BL scanf                @ call scanf
LDR R0, [SP]            @ load value at SP into R0
ADD SP, SP, #4          @ restore the stack pointer
POP {PC}                 @ return

readloop:
CMP R0, #10           @ check to see if we are done iterating
BEQ readdone            @ exit loop if done
LDR R1, =a              @ get address of a
LSL R2, R0, #2          @ multiply index*4 to get array offset
ADD R2, R1, R2          @ R2 now has the element address
LDR R1, [R2]            @ read the array at address
PUSH {R0}               @ backup register before printf
PUSH {R1}               @ backup register before printf
PUSH {R2}               @ backup register before printf
MOV R2, R1              @ move array value to R2 for printf
MOV R1, R0              @ move array index to R1 for printf
BL  _printf             @ branch to print procedure with return
POP {R2}                @ restore register
POP {R1}                @ restore register
POP {R0}                @ restore register
ADD R0, R0, #1          @ increment index
B   readloop            @ branch to next loop iteration

readdone:
B _exit                 @ exit if done

_printf:
PUSH {LR}               @ store the return address
LDR R0, =printf_str     @ R0 contains formatted string address
BL printf               @ call printf
POP {PC}                @ restore the stack pointer and return

.data
a:              .skip       40
format_str:     .asciz      "%d"
start_message:             .asciz      "Enter 10 positive integers, each followed by ENTER:\n"
printf_str:     .asciz      "a[%d] = %d\n"
