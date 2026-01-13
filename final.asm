.data
prompt: .asciiz "Enter 15 non-zero integers:\n"
name:   .asciiz "\nMuqtada Shihadi\n"
msgA:   .asciiz "\nCount of A (Negative) = "
msgB:   .asciiz "Count of B (Positive Even) = "
msgC:   .asciiz "Count of C (Positive Odd) = "
msgSortA: .asciiz "\nSorted A (Descending): "
msgAvgB: .asciiz "\nAverage of B = "
msgMaxMin: .asciiz "\nMax / Min in C = "
space: .asciiz " "
nl:     .asciiz "\n"

.align 2
A: .space 64
B: .space 64
C: .space 64

.text
.globl main

main:

    li $t7,0      
    li $s3,0      
    li $s4,0      
    li $s5,0      

    li $v0,4
    la $a0,prompt
    syscall

read_loop:
    beq $t7,15,done_input     

    li $v0,5
    syscall
    move $t0,$v0              

    beq $t0,$zero,read_loop   

    bltz $t0,putA             

    andi $t1,$t0,1            
    beq  $t1,1,putC           

putB:
    sll $t2,$s4,2             
    la  $t3,B
    addu $t4,$t3,$t2
    sw  $t0,0($t4)            
    addi $s4,$s4,1            
    addi $t7,$t7,1            
    j read_loop

putA:
    sll $t2,$s3,2
    la  $t3,A
    addu $t4,$t3,$t2
    sw  $t0,0($t4)
    addi $s3,$s3,1
    addi $t7,$t7,1            
    j read_loop

putC:
    sll $t2,$s5,2
    la  $t3,C
    addu $t4,$t3,$t2
    sw  $t0,0($t4)
    addi $s5,$s5,1
    addi $t7,$t7,1            
    j read_loop

done_input:

    sll $t2,$s3,2
    la $t3,A
    addu $t4,$t3,$t2
    sw $zero,0($t4)            

    sll $t2,$s4,2
    la $t3,B
    addu $t4,$t3,$t2
    sw $zero,0($t4)            

    sll $t2,$s5,2
    la $t3,C
    addu $t4,$t3,$t2
    sw $zero,0($t4)            
    

######## PRINT RESULTS ########

    li $v0,4
    la $a0,name
    syscall

    li $v0,4
    la $a0,msgA
    syscall
    li $v0,1
    move $a0,$s3
    syscall
    li $v0,4    
    la $a0,nl
    syscall

    li $v0,4
    la $a0,msgB
    syscall
    li $v0,1
    move $a0,$s4
    syscall
    li $v0,4  
    la $a0,nl
    syscall

    li $v0,4
    la $a0,msgC
    syscall
    li $v0,1
    move $a0,$s5
    syscall
    li $v0,4     
    la $a0,nl
    syscall


##############################################################
# SORT ARRAY A IN DESCENDING ORDER
##############################################################

    move $t7, $s3          # t7 = countA

sort_outer_A:
    addi $t8, $t7, -1
    blez $t8, sortA_done   

    li $t9, 0              
    la $t6, A              

sort_inner_A:
    beq  $t9, $t8, next_outer_A   

    lw $a0, 0($t6)        
    lw $a1, 4($t6)        

    ble $a0, $a1, no_swap_A   

    sw $a1, 0($t6)
    sw $a0, 4($t6)

no_swap_A:
    addi $t6, $t6, 4
    addi $t9, $t9, 1
    j sort_inner_A

next_outer_A:
    addi $t7, $t7, -1
    j sort_outer_A

sortA_done:

##############################################################
# PRINT SORTED A
##############################################################

    li $v0,4
    la $a0,msgSortA
    syscall

    la $t6,A

print_sorted_A:
    lw $a0,0($t6)
    beq $a0,$zero, afterPrintA

    li $v0,1
    syscall

    li $v0,4
    la $a0,space
    syscall

    addi $t6,$t6,4
    j print_sorted_A

afterPrintA:


##############################################################
# AVERAGE OF B
##############################################################

    li $v0,4
    la $a0,msgAvgB
    syscall

beq $s4, $zero, printAvgZero

li $t0,0
li $t1,0
la $t2,B   

sum_loop:
    bge $t1, $s4, do_div      
    lw $t3, 0($t2)            
    add $t0, $t0, $t3         
    addi $t2, $t2, 4          
    addi $t1, $t1, 1          
    j sum_loop

do_div:
    div $t0, $s4              
    mflo $a0                  
    li $v0,1                 
    syscall

    li $v0,4
    la $a0,nl
    syscall

    j afterAvg

printAvgZero:
    li $a0,0
    li $v0,1
    syscall

    li $v0,4
    la $a0,nl
    syscall

afterAvg:


##############################################################
# MAX / MIN FOR C
##############################################################

li $v0,4
la $a0, msgMaxMin
syscall

beq $s5, $zero, printZeroMaxMin

la $a0, C
jal findMaxMin   

move $t6, $v0    

li $v0,1
move $a0,$t6     
syscall

li $v0,4
la $a0,space
syscall

li $v0,1
move $a0,$v1
syscall

li $v0,4
la $a0,nl
syscall
j afterMaxMin

printZeroMaxMin:
li $v0,1
li $a0,0
syscall
li $v0,4
la $a0,space
syscall
li $v0,1
li $a0,0
syscall
li $v0,4
la $a0,nl
syscall

afterMaxMin:

li $v0,4
la $a0,nl
syscall

li $v0,10
syscall


##############################################################
# PROCEDURE: find max & min 
##############################################################

findMaxMin:
    lw $t0, 0($a0)
    move $v0, $t0      
    move $v1, $t0      

loopMM:
    addi $a0, $a0, 4   
    lw $t0, 0($a0)
    beq $t0, $zero, endMM

    blt $t0, $v1, setMin
    bgt $t0, $v0, setMax
    j loopMM

setMin:
    move $v1, $t0
    j loopMM

setMax:
    move $v0, $t0
    j loopMM

endMM:
    jr $ra
