.data
msg1: .asciiz "\n Programming Assigment 1 \n"
msg2: .asciiz ","
msg3: .asciiz "Before sorting:"
msg4: .asciiz "After sorting:"
msg5: .asciiz "\n"

.align 4
len:  .word 6
array:.word 33, 100, 5, 666, 99, 11

.text 					
.globl main
main:    
    li      $v0,4           # print msg3
    la      $a0,msg3        # address where msg3 is stored 	
    syscall	
    jal     printall        # print the array before sorting

# open Window->Console menu to see outputs.
# // Bobble sort in C. 
# for(int i = 1; i < n; i++) {
#     for(int j = 0; j < n - i; j++) {
#         if (v[j] > v[j+1])
#             swap(v, j);
#     }
# }	
    li      $v0,4           # print msg4
    la      $a0,msg4        # address where msg3 is stored 
    syscall	
                       
    la      $a0,array       # first parameter is v[] (address of the array)
    lw      $a1,len         # second parameter is n (length of the array)
    jal     sort            # jump to sort and save position to $ra

    jal     printall        # print the array after sorting

    li      $v0,10          # code for syscall: exit
	syscall                # The program exits here! 


# =============== Your code starts here ============

sort:
			addi $sp, $sp, -20					# make room on stack for 5 registers
			sw $ra, 16($sp)						# save $ra on stack
			sw $s3, 12($sp)						# save $s3 on stack
			sw $s2, 8($sp)						# save $s2 on stack
			sw $s1, 4($sp)						# save $s1 on stack
			sw $s0, 0($sp)						# save $s0 on stack

			move $s3, $a0						# backup $a0 (v) to $s3
			move $s0, $zero						# i = 0
			addi $s0, $s0, 1					# i is now 1
	for1tst:slt $t0, $s0, $a1					# reg $t0 = 0 if $s0 >= $a1 (i >= n)
			beq $t0, $zero, exit1				# go to exit1 if $s0 >= $a1 (i >= n)
												# body of outer loop starts
			move $s1, $zero						# j = 0
			sub $s2, $a1, $s0					# $s2 = $a1 - $s0 (n - i)
	for2tst:slt $t0, $s1, $s2					# $t0 = 0 if $s1 >= $s2 (j >= n - i)
			beq $t0, $zero, exit2
												# body of inner loop starts
			sll $t1, $s1, 2						# $t1 = j * 4
			add $t2, $a0, $t1					# $t2 = v + (j * 4)
			lw $t3, 0($t2)						# $t3 = v[j]
			lw $t4, 4($t2)						# $t4 = v[j+1]
			slt $t0, $t4, $t3					# $t0 = 0 if $t4 >= $t3 (v[j+1] >= v[j])
			beq $t0, $zero, incr				# if $t0 != 0 (v[j] < v[j+1]) jump to next iteration of inner loop
												# else swap
			move $a0, $s3
			jal swap
												# body of inner loop ends
	incr:	addi $s1, $s1, 1					# j += 1
			j for2tst							# jump to test of inner loop
												# body of outer loop ends
	exit2:	addi $s0, $s0, 1					# i += 1
			j for1tst							# jump to test of outer loop
												# restoring from stack
	exit1:	lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $ra, 16($sp)
			addi $sp, $sp, 20

			jr $ra								# return to calling routine

swap:
	sll $t1, $s1, 2			# $t1 = j * 4
	add $t1, $a0, $t1		# $t1 = v + (j * 4)
							# $t1 has the address of v[j]
	lw $t0, 0($t1)			# $t0 = v[j]
	lw $t2, 4($t1)			# $t2 = v[j+1]
							# now, swap
	sw $t2, 0($t1)
	sw $t0, 4($t1)

	jr $ra					# return to calling routine, in this case, sort

# ================ Your code ends  here ==================
    
# ** expected output **
# Before sorting:
# 33,100,5,666,99,11,
# After sorting:
# 5,11,33,99,100,666,
    


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
