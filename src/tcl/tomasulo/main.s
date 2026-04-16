lw $t0, 0($t4)
lw $t1, 4($t4)
lw $t2, 8($t4)
add $t3, $t0, $t1
add $t3, $t3, $t2
sw $t3, 12($t4)
