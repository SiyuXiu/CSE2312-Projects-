

.global main
.func main

main:
BL  _prompt
BL  _scanfint
MOV R4, R0
BL  _scanfchar            @ branch to scanf procedure with return
MOV R5, R0
BL  _scanfint
MOV R6, R0
MOV R1, R4
MOV R2, R6
BL  _command
MOV R1, R0              @ copy return value to R1
BL  _printf             @ print value stored in R1
B   main                @ loop to main procedure with no return




_exit:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #52             @ print string length
LDR R1,=exit_str        @ string at label exit_str:
SWI 0                   @ execute syscall
MOV R7, #1              @ terminate syscall, 1
SWI 0                   @ execute syscall




_command:
MOV R7, LR
CMP R5, #'@'
BEQ _exit
CMP R5, #'+'
BEQ _sum
CMP R5, #'-'
BEQ _sub
CMP R5, #'*'
BEQ _mul
CMP R5, #'M'
BEQ _max
BNE _exit

_sum:
MOV R0, R1
ADD R0, R2
MOV PC, R7

_sub:
MOV R0, R1
SUB R0, R2
MOV PC, R7

_mul:
MOV R0, R1
MUL R0, R2
MOV PC, R7



_max:
CMP R1, R2          @compare R1 with R2
MOVLE R1, R2        @overwrite R1 with R2 if R1 is lesser than or equal to R3
MOV R0, R1          @ move the value from reg R1 to reg R0
MOV PC, R7

_scanfchar:
MOV R7, #3              @ write syscall, 3
MOV R0, #0              @ input stream from monitor, 0
MOV R2, #1              @ read a single character
LDR R1, =read_char      @ store the character in data memory
SWI 0                   @ execute the system call
LDR R0, [R1]            @ move the character to the return register
AND R0, #0xFF           @ mask out all but the lowest 8 bits
MOV PC, LR              @ return

_scanfint:
PUSH {LR}               @ store LR since scanf call overwrites
SUB SP, SP, #4          @ make room on stack
LDR R0, =input          @ R0 contains address of format string
MOV R1, SP              @ move SP to R1 to store entry on stack
BL scanf                @ call scanf
LDR R0, [SP]            @ load value at SP into R0
ADD SP, SP, #4          @ restore the stack pointer
POP {PC}                @ return

_printf:
MOV R4, LR              @ store LR since printf call overwrites
LDR R0,=printf_str      @ R0 contains formatted string address
BL printf               @ call printf
MOV LR, R4              @ restore LR from R4
MOV PC, LR              @ return

_prompt:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #96             @ print string length
LDR R1, =prompt_str     @ string at label prompt_str:
SWI 0                   @ execute syscall
MOV PC, LR              @ return



.data
read_char   :      .ascii      " "
prompt_str:        .asciz      "Please follow: \n <OPERAND_1><ENTER>\n<OPERATION_CODE><ENTER>\n<OPERAND_2><ENTER>\n type <1@1><ENTER> to exit\n"


printf_str  :      .asciz      "%d\n"
exit_str    :      .ascii      "OPERATION_CODE is not +,-,*,M. Terminating program.\n"
input       :      .asciz      "%d"
