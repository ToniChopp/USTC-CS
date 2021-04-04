 .text
     j main
 .data 
     .word  0,7,0

.text 
main:
    addi $s0, $zero, 0
    addi $s1, $zero, 1
    add $s2, $zero, $zero
    addi $s3, $zero, 1
    lw $s4,4($0)
    #addi $s4, $zero, 12
loop:
    beq $s3, $s4, success
    add $s2, $s1, $s0
    add $s0, $zero, $s1
    add $s1, $zero, $s2
    addi $s3, $s3, 1
    j loop
success: 
    sw $s2, 12($zero)
