.data
msg1: .asciiz "\n Programming Assigment 2 \n"
msg2: .asciiz ","
msg3: .asciiz "Array Values:"
msg4: .asciiz "Fibonacci Values:\n"
msg5: .asciiz "\n"
newLine: .asciiz ","

.align 4
len:  .word 8
length: .word 8
array:.word 19, 25, 10, 0, 15, 1, 22, 2
answer: .word 0
.text
.globl main
main:
li      $v0,4
la      $a0,msg3
syscall
jal     printall

li      $v0,4
la      $a0,msg4
syscall

la $s0, array
li $s1, 0
lw $s2, length
printLoop:
li $v0, 1 # copy
lw $a0, ($s0) # Load word and array[i] getter

 jal fib
 sw $v0,answer  #Store word sequence
 li $v0, 1 # Integer's Printing
 lw $a0, answer
 syscall
###Fib callEnds
addu $s0, $s0, 4
add $s1, $s1, 1 # Incrementing the counter
li $v0, 4 # new line
la $a0, newLine
syscall

bne $s1, $s2, printLoop # if cnter<len -> loop
# Done, terminate program.
 li $v0, 10 # Code for syscall: exit
 syscall # The program exits here
 .end main

# =============== Your code starts here =============================
.globl fib
.ent fib
fib:
 subu $sp, $sp, 8
 sw $ra, ($sp)  #Store word
 sw $s0, 4($sp) #Store word
 move $v0, $a0 #Base cases checking
 ble $a0, 1, fibDone
 move $s0, $a0 # get fib(n-1)
 sub $a0, $a0, 1  #MIPS substract
 jal fib  #Jump and link fib
 move $a0, $s0  #Moving
 sub $a0, $a0, 2  #Subtract inside an array
 move $s0, $v0 # save fib(n-1)
 jal fib # get fib(n-2) with jumping and linking
 add $v0, $s0, $v0 # fib(n-1)+fib(n-2)
 fibDone: lw $ra, ($sp) #Fib sequence completion
 lw $s0, 4($sp)   #Load word
 addu $sp, $sp, 8
 jr $ra
 .end fib		# return to calling routine
# ================ Your code ends  here ==========================

# ** Expected output **
# Array Values:
# 19,25,10,0,15,1,22,2,
# 4181,75025,55,0,610,1,17711,1,

# ================ Print Array Function ====================
printall:
    la      $t0,array
    ld      $t1,len
    add     $t4,$zero,$zero
    li      $v0,4           # system call to print the string
    la      $a0,msg5
    syscall
imprime:
    li      $v0,1           # system call to print integer
    lw      $a0,0($t0)
    syscall
    li      $v0,4           # system call to print ","
    la      $a0,msg2
    syscall
    addi    $t4,1
    addi    $t0,4
    bne     $t4,$t1,imprime
    li      $v0,4           # change line
    la      $a0,msg5
    syscall
    jr      $ra             # return to calling routine
