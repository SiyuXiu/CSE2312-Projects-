

/******************************************************************************
   @CSE2312-project2
   @rand_array.s
   @author Christopher D. McMurrough
   @Student name:Siyu Xiu
   @Student ID: 1001394663
 ******************************************************************************/

.global main
.func main

main:
   BL _seedrand            @ seed random number generator with current time
   MOV R0, #0              @ initialze index variable

writeloop:
   CMP R0, #10            @ check to see if we are done iterating
   BEQ writedone           @ exit loop if done
   LDR R1, =a              @ get address of a
   LSL R2, R0, #2          @ multiply index*4 to get array offset
   ADD R2, R1, R2          @ R2 now has the element address
   PUSH {R0}               @ backup iterator before procedure call
   PUSH {R2}               @ backup element address before procedure call
   BL _getrand             @ get a random number
   POP {R2}                @ restore element address
   STR R0, [R2]            @ write the address of a[i] to a[i]
   POP {R0}                @ restore iterator
   ADD R0, R0, #1          @ increment index
   B   writeloop           @ branch to next loop iteration

writedone:
   MOV R0, #0              @ initialze index variable

readloop:
   CMP R0, #10            @ check to see if we are done iterating
   BEQ readdone            @ exit loop if done
   LDR R1, =a              @ get address of a
   LSL R2, R0, #2          @ multiply index*4 to get array offset
   ADD R2, R1, R2          @ R2 now has the element address
   LDR R1, [R2]            @ read the array at address
   PUSH {R0}               @ backup register before printf
   PUSH {R1}               @ backup register before printf
   PUSH {R2}               @ backup register before printsf
   MOV R2, R1              @ move array value to R2 for printf
   MOV R1, R0              @ move array index to R1 for printf
   BL  _printf             @ branch to print procedure with return
   POP {R2}                @ restore register
   POP {R1}                @ restore register
   POP {R0}                @ restore register
   ADD R0, R0, #1          @ increment index
   B   readloop            @ branch to next loop iteration

readdone:
   MOV R0, #0                @ resets register to 0

_initMaxMin:                 @ initialze the min value and the max value
   MOV R1, #0                @ resets register to 0
   MOV R2, #0                @ resets register to 0
   LDR R1, =a                @ get address of a
   LSL R2, R0, #2            @ multiply index*4 to get array offset
   ADD R2, R1, R2            @ R2 now has the element address
   LDR R1, [R2]              @ read the array at address
   MOV R3, R1                @ move R1 value to R3 to get the min value
   MOV R4, R1                @ move R1 value to R4 to get the max value
   B _compareloop            @ branch to min max loops

_compareloop:                @ find the max value and the min value
   CMP R0, #10               @ check whether these 10 numbers have already been compared
   BEQ _compareprint         @ if all numbers are compared, print the mix value and max value
   LDR R5, =a                @ get address of a
   LSL R6, R0, #2            @ multiply index*4 to get array offset
   ADD R6, R5, R6            @ R6 now has the element address
   LDR R5, [R6]              @ read the array at address
   CMP R3, R5                @ compares current value (R5) with the min in the arrry(R3)
   MOVGT R3, R5              @ if R3 is greater than R5, move R5 to R3[the value of R5 is the min]
   CMP R4, R5                @ compares current value (R5) with the max in the arrry(R3)
   MOVLT R4, R5              @ if the max of the array(R4) is lighter than current value, then move R5 to R4 [the valueof R5 is the max]
   ADD R0, R0, #1            @ count how many numbers have compared
   B _compareloop            @ return to loop

_compareprint:
   MOV R1, R3                @ move R3(the min value) to R1
   LDR R0, =print_min         @ print the min value
   BL printf                 @ call printf
   MOV R1, R4                @ move R4(the max value) to R1
   LDR R0, =print_max         @ print the max value
   BL printf                 @ call printf
   B _exit

 _exit:
   MOV R7, #4                @ write syscall, 4
   MOV R0, #1                @ output stream to monitor, 1
   MOV R2, #24               @ print string length
   LDR R1, =exit_str         @ string at label exit_str:
   SWI 0                     @ execute syscall
   MOV R7, #1                @ terminate syscall, 1
   SWI 0                     @ execute syscall


 _printf:
   PUSH {LR}                 @ store the return address
   LDR R0, =printf_str       @ R0 contains formatted string address
   BL printf                 @ call printf
   POP {PC}                  @ restore the stack pointer and return

_seedrand:
   PUSH {LR}                 @ backup return address
   MOV R0, #0                @ pass 0 as argument to time call
   BL time                   @ get system time
   MOV R1, R0                @ pass sytem time as argument to srand
   BL srand                  @ seed the random number generator
   POP {PC}                  @ return

_getrand:
   PUSH {LR}               @ backup return address
   BL rand                 @ get a random number
   MOV R1, #1000           @ limit the range of number from 0 to 999
   MOV R2, R0
   BL _mod_unsigned        @ compute the remainder of R1 / R2
   POP {PC}                @ return

_mod_unsigned:
   cmp R2, R1              @ check to see if R1 >= R2
   MOVHS R0, R1            @ swap R1 and R2 if R2 > R1
   MOVHS R1, R2            @ swap R1 and R2 if R2 > R1
   MOVHS R2, R0            @ swap R1 and R2 if R2 > R1
   MOV R0, #0              @ initialize return value
   B _modloopcheck         @ check to see if
   _modloop:
      ADD R0, R0, #1        @ increment R0
      SUB R1, R1, R2        @ subtract R2 from R1
   _modloopcheck:
      CMP R1, R2            @ check for loop termination
      BHS _modloop          @ continue loop if R1 >= R2
      MOV R0, R1            @ move remainder to R0
      MOV PC, LR            @ return

.data

.balign 4
a:              .skip       40
printf_str:     .asciz      "a[%d] = %d\n"
print_min:      .asciz      "MINIMUM VALUE = %d\n"
print_max:      .asciz      "MAXIMUM VALUE = %d\n"
exit_str:       .ascii      "Program is terminating.\n"
