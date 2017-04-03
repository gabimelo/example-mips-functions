# @author Gabriela Melo
# @since 08/04/2015
# @modified 17/04/2015

# test cases
# output: function bitwise_power(b,e) is working properly

			.data
correct: 	.word 	1
b1: 		.word	4
e1: 		.word	2
result1:	.word 	16
b2: 		.word	3
e2: 		.word	4
result2: 	.word 	81
ifcorrect:	.asciiz "Function power(b,e) is working properly"
ifnot:		.asciiz "Function power(b,e) is not working properly"

			.text

			addi 	$sp, $sp, -8 	# pass b1 and e1 as argument
			lw 		$t0, b1
			sw 		$t0, 4($sp)
			lw 		$t0, e1
			sw 		$t0, ($sp)

			jal 	bitwise_power

			addi 	$sp, $sp, 8 	# pops space allocated for arguments
			lw 		$t0, result1
			beq 	$v0, $t0, test2
			lw 		$0, correct

test2:		addi 	$sp, $sp, -8 	# pass b2 and e2 as argument
			lw 		$t0, b2
			sw 		$t0, 4($sp)
			lw 		$t0, e2
			sw 		$t0, ($sp)

			jal 	bitwise_power

			addi 	$sp, $sp, 8 	# pops space allocated for arguments
			lw 		$t0, result2
			beq 	$v0, $t0, end
			lw 		$0, correct

end:		lw	$t0, correct
			beq 	$0, $t0, false
			la		$a0, ifcorrect	# print ifcorrect
			addi	$v0, $0, 4
			syscall
			j 		exit
false:		la		$a0, ifnot	# print ifnot
			addi	$v0, $0, 4
			syscall

exit:		addi	$v0, $0, 10	# exit
			syscall 

# @param: base and exponent
# @pre: none
# @post: returns b**e
# @complexity: ?????

# memory map

# n
# idx
# i
# result
# old fp
# ra
# e
# b

bitwise_power: 	
			addi 	$sp, $sp, -8
			sw 		$ra, 4($sp)
			sw 		$fp, ($sp)
			addi 	$fp, $sp, 0

			addi 	$sp, $sp, -16

			addi 	$t0, $0, 1
			sw 		$t0, -4($fp)
			sw 		$t0, -8($fp)
			sw 		$0, -12($fp)

bit_loop1: 							# while i&e != e:
			lw		$t0, -8($fp) 	# $t0 = i
			lw		$t1, 8($fp) 	# $t1 = e
			and 	$t0, $t0, $t1  	# $t0 = i & e
			lw		$t1, 8($fp) 	# $t1 = e
			beq 	$t0, $t1, bit_loop2

			lw		$t0, -8($fp) 	# $t0 = i
			sll 	$t0, $t0, 1 	# $t0 = i << 1
			addi 	$t1, $0, 1 		# $t1 = 1
			or	 	$t0, $t0, $t1 	# $t0 = i<<2 | 1
			sw 		$t0, -8($fp) 	# i = i<<2 | 1

			lw 		$t0, -12($fp) 	# $t0 = idx
			addi 	$t0, $t0, 1 	# $t0 = idx + 1
			sw 		$t0, -12($fp) 	# idx += 1

			j 		bit_loop1

bit_loop2:							# while idx >= 0:
			lw 		$t0, -12($fp)	# $t0 = idx
			blt 	$t0, $0, endbit_loop2

			lw 		$t0, -4($fp) 	# $t0 = result
			mul 	$t0, $t0, $t0 	# $t0 = result * result
			sw 		$t0, -4($fp) 	# result *= result
			addi 	$t0, $0, 1 		# $t0 = 1
			sw 		$t0, -8($fp) 	# i = 1
			sw 		$0, -16($fp) 	# n = 0
			lw 		$t1, -12($fp) 	# $t1 = idx
			addi 	$t1, $t1, 1 	# $t1 = idx + 1

bit_loop3: 							# for n in range(idx):
			lw 		$t2, -16($fp) 	# $t2 = n
			beq 	$t2, $t1, bit_if

			lw 		$t2, -8($fp) 	# $t2 = i
			mul 	$t2, $t2, $t0 	# $t2 = i<<1
			sw 		$t2, -8($fp) 	# i = i<<1
			
			lw 		$t2, -16($fp) 	# $t2 = n
			addi 		$t2, $t2, 1 	# $t2 = n+1
			sw 		$t2, -16($fp) 	# n += 1

			j 		bit_loop3

bit_if: 							# if (i&e != 0):
			lw		$t0, -8($fp) 	# $t0 = i
			lw		$t1, 8($fp) 	# $t1 = e
			and 	$t0, $t0, $t1  	# $t0 = i & e
			beq 	$t0, $0, endbit_if

			lw 		$t0, -4($fp) 	# $t0 = result
			lw 		$t1, 12($fp) 	# $t1 = b
			mul 	$t0, $t0, $t1 	# $t0 = result * b
			sw 		$t0, -4($fp) 	# result *= b

endbit_if:
			lw 		$t0, -12($fp) 	# $t0 = idx
			addi 	$t0, $t0, -1 	# $t0 = idx - 1
			sw 		$t0, -12($fp) 	# idx -= 1

			j 		bit_loop2

endbit_loop2:
			lw 		$v0, -4($fp) 	# $v0 = result

			addi 	$sp, $sp, 16

			lw 		$fp, ($sp)
			lw 		$ra, 4($sp)
			addi 	$sp, $sp, 8

			jr 		$ra