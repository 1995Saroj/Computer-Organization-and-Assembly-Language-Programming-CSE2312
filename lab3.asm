.data
msg1: .asciiz "\n Programming Assignment 3 \n"
msg2: .asciiz ","
msg3: .asciiz "Linked List:"
msg5: .asciiz "\n"

.align 4
# You need to insert the value in the input array to the linked list A.
len:  .word 10
input:.word 5, 10, 2, 4, 15, 22, 100, 99, 2, 10

# 'head' stores the address of the first node of the linked list
head: .word 0
# Total number of inserted numbers
size: .word 0
# allocate a block of 80 bytes, 20 words: 10 for number, 10 for pointer
A: .space 80

.text
.globl main
main:
# $s0: i
# $s1: 10
# $s2: input
# $s3: head address
# $s4: size
# $s5: A address
    li      $v0,4                      # print msg3
    la      $a0,msg3                   # address where msg3 is stored
    syscall

    add     $s0,$zero,$zero # i = 0
    addi    $s1,$zero,10
    la      $s2,input
    la      $s3,head
    lw      $s4,size
    la      $s5,A
buildList:
    beq     $s0,$s1,end
    sll     $t0,$s0,2
    add     $t1,$t0,$s2

    lw      $a0,0($t1)                 # $a0 = input[i]
    jal     insert

    addi    $s0,1
    j       buildList
end:
    jal     printValueOfList           # print the linked list after sorting

    li      $v0,10                     # code for syscall: exit
    syscall

insert:
# ================ Your Code Starts Here ====================
                                       # $a0 = a_num
                                       # $s3 = head = p
    move    $t9, $s3                   # just saving head
    add     $t4, $zero, $zero          # $t4 = p_prev = NULL
    li      $s6, 8                     # $s6 = 8
    mult    $s6, $s4                   # LO = $s6 * $s4 = 8 * $s4 = 8*size
    mflo    $s6                        # $s6 = LO
    add     $s7, $s5, $s6              # $s7 = $s5 + $s6 = A + 8*$s4 = A + 8*size = address of A[i]
    sw      $a0, 0($s7)                # $a0 = A[i]
    bne	    $s4, $zero, else_outer     # if size (i.e. $s4) = 0, goto else_outer
                                       # when size = 0
    move    $s3, $s7                   # head (i.e. $s3) = address of A[0] (i.e. $s7)
    sw      $zero, 4($s7)              # A[0].next = 4($s7) = 0 (i.e. NULL)
    addi    $s4, $s4, 1                # size++
#   li      $v0, 1                     # system call to print integer (just for debugging)
#   lw      $a0, 0($s7)
#   syscall
    jr     $ra                         # return
else_outer:
                                       # while loop
                                       # $a0 = a_num
                                       # $s3 = head = p
                                       # 0($s3) = address of p->num
    lw      $t2, 0($s3)                # $t2 = p->num
    slt     $t3, $t2, $a0              # $t3 = ($t2 < $a0)
    bne     $t3, $zero, while_do       # if $t2 < $a0, goto while_do
    j       if_inner_cond              # else goto if_inner_cond
while_do:
    move    $t4, $s3                   # $t4 = p_prev = p
    addi    $s3, $s3, 4                # p = p->next
    lw      $t5, 0($s3)                # $t5 = node address in p (which is basically p->next from before)
    move    $s3, $t5                   # head = node address in p
    bne     $t5, $zero, else_outer     # if node address in p != NULL, goto else_outer (continue with while loop)
                                       # else break from while loop
                                       # inner if
if_inner_cond:
    bne     $t4, $zero, if_inner       # if p_prev != NULL, goto if_inner
                                       # else goto inner else block
                                       # inner else
	move    $t6, $t9                   # $t6 = $t9 = head (backed up one)
    sw      $t6, 4($s7)                # 4($s7) = $t6 (i.e. A[size].next = head)
    move    $t6, $s7                   # head = A[size]
    move    $s3, $t6
    addi    $s4, $s4, 1                # size++
    jr      $ra                        # return
if_inner:
    sw      $s7, 4($t4)                # p_prev->next (i.e. 4($t4)) = A[size] (i.e. $s7)
    sw      $t5, 4($s7)                # A[size].next (i.e. 4($s7)) = $t5 (i.e. p)
end_insert:
    addi    $s4, $s4, 1                # size++
    move    $s3, $t9                   # restore from backed up head
    jr      $ra                        # return

# ================ Your Code Ends Here ====================

# Now $s3 points to head; So, load $s3 into $t0
# ================ Print Linked List ====================
printValueOfList:
# $t0: p = head
    move    $t0,$s3
    add     $t4,$zero,$zero
    li      $v0,4                      # system call to print the string
    la      $a0,msg5
    syscall
printLoop:
    beq     $t0,$zero,endLoop          # if p == NULL, break loop

    li      $v0,1                      # system call to print integer
    lw      $a0,0($t0)
    syscall
    li      $v0,4                      # system call to print ","
    la      $a0,msg2
    syscall

    lw      $t0,4($t0)                 # p = p->next;
    j       printLoop
endLoop:
    li      $v0,4                      # change line
    la      $a0,msg5
    syscall
    jr      $ra                        # return to calling routine
