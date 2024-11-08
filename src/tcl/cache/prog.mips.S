	.file	1 "prog.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.gnu_attribute 4, 1
	.text
	.align	2
	.globl	a_routine
	.set	nomips16
	.set	nomicromips
	.ent	a_routine
	.type	a_routine, @function
a_routine:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	lw	$2,0($4)
	lw	$3,4($4)
	nop
	addu	$2,$2,$3
	beq	$2,$0,$L2
	nop

	addiu	$2,$2,1
$L2:
	sw	$2,16($5)
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	a_routine
	.size	a_routine, .-a_routine
	.ident	"GCC: (GNU) 4.9.2"
