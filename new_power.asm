# @author Gabriela Melo
# @since 08/04/2015
# @modified 17/04/2015

# test cases
# output: function power(b,e) is working properly

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

		# pass b1 and e1 as argument
			addi 	$sp, $sp, -8 	# allocates space on stack
			lw 		$t0, b1 		# $t0 = b1
			sw 		$t0, 4($sp) 	# passes b1 as argument
			lw 		$t0, e1 		# $t0 = e1
			sw 		$t0, ($sp) 		# passes e1 as argument

			jal 	power

			addi 	$sp, $sp, 8 	# clears arguments off stack
			lw 		$t0, result1 	# $t0 = result1
			beq 	$v0, $t0, test2 # compares result1 with return value
			lw 		$0, correct 	# if not equal, sets correct to 0

test2:	# pass b2 and e2 as argument	
			addi 	$sp, $sp, -8 	
			lw 		$t0, b2
			sw 		$t0, 4($sp)
			lw 		$t0, e2
			sw 		$t0, ($sp)

			jal 	power

			addi 	$sp, $sp, 8 
			lw 		$t0, result2
			beq 	$v0, $t0, end
			lw 		$0, correct

end:		lw		$t0, correct 	# $ t0 = correct
			beq 	$0, $t0, false 	# if correct = 0 goto false

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
# @pre: binary and reverse are defined
# @post: returns b**e
# @complexity: ?????

# memory map:

# idx
# result
# rev_binary
# old fp
# ra
# e
# b

power: 	# stores $ra and $fp and updates $fp
			addi 	$sp, $sp, -8
			sw 		$ra, 4($sp)
			sw 		$fp, ($sp)
			addi 	$fp, $sp, 0

		# allocate space for local variables
			addi 	$sp, $sp, -12

		# rev_binary = binary(e)

		# passes e as argument
			addi 	$sp, $sp, -4 	
			lw 		$t0, 8($fp) 	# $t0 = e
			sw 		$t0, ($sp) 		

			jal 	binary

			addi 	$sp, $sp, 4 	# clear arguments off stack

			sw 		$v0, -4($fp)	# rev_binary = $v0

		# passes rev_binary as argument
			addi 	$sp, $sp, -4
			lw 		$t0, -4($fp) 	# $t0 = rev_binary 	
			sw 		$t0, ($sp) 		
			
call:		jal 	reverse
			
			addi 	$sp, $sp, 4 	# clears arguments off stack 
			
			addi 	$t0, $0, 1 		# $t0 = 1
			sw 		$t0, -8($fp) 	# result = 1

			lw 		$t0, -4($fp) 	# $t0 = rev_binary
			lw		$t1, ($t0)		# $t1 = len(rev_binary)  
			sub 	$t1, $t1, 1 	# $t1 = len(rev_binary) - 1
			sw 		$t1, -12($fp)	# idx = len(rev_binary) - 1

power_loop1: # while idx >= 0
			lw 		$t0, -12($fp)	# $t0 = idx
			blt 	$t0, $0, endpower_loop1

			lw 		$t1, -8($fp) 	# $t1 = result
			mul 	$t1, $t1, $t1 	# $t1 = result * result

			lw		$t2, -4($fp) 	# $t2 = rev_binary
			addi	$t3, $0, 4 		# $t3 = 4
			mult	$t3, $t0
			mflo	$t4		 		# $t4 = idx*4
			add		$t4, $t4, $t3	# $t4 = idx*4 + 4
			add		$t4, $t4, $t2	# $t4 = idx*4 + 4 + rev_binary
			lw		$t5, ($t4)		# $t5 = rev_binary[idx]

			beq 	$t5, $0, not 	# if rev_binary[idx] = 0 goto not
			lw 		$t2, 12($fp)	# $t2 = b
			mul 	$t1, $t1, $t2 	# $t1 = result * b
			sw 		$t1, -8($fp) 	# result *= b

not:		lw 		$t0, -12($fp)	# $t0 = idx
			sub 	$t0, $t0, 1 	# $t0 -= 1
			sw 		$t0, -12($fp)	# idx -= 1

			j 		power_loop1

endpower_loop1:

			lw 		$v0, -8($fp) 	# $v0 = result

			addi 	$sp, $sp, 12

			lw 		$fp, ($sp)
			lw 		$ra, 4($sp)
			addi 	$sp, $sp, 8
			jr 		$ra
			
# @param: positive integer to be returned in binary representation
# @pre: reverse is defined
# @post: returns a list with the binary representation of number passed as parameter
# @complexity: 

#memory map:

# n
# i
# aux
# rev_bin
# old fp
# ra
# num

binary:	# stores $fp and $ra and update $fp
			addi 	$sp, $sp, -8
			sw 		$ra, 4($sp)
			sw 		$fp, ($sp)
			addi 	$fp, $sp, 0

		# allocate space for local variables	
			sub 	$sp, $sp, 16

		# rev_binary = [0]*num
		# allocate memory
			lw		$t0, 8($fp)	 	# $t0 = num
			addi	$t1, $0, 4 		# $t1 = 4
			mult	$t1, $t0 
			mflo	$t2 			# $t2 = num*4
			add		$a0, $t2, $t1	# a0 = num*4 + 4
			addi	$v0, $0, 9
			syscall

			sw		$v0, 12($sp)	# rev_bin points to the allocated memory
			sw		$t0, ($v0)		# rev_bin[0] = num (size of rev_bin)

			sw		$0, ($sp)		# n = 0
		
bin_loop1: # if n >= num goto endbin_loop1	
			lw		$t0, ($sp)		# $t0 = n
			lw		$t1, 8($fp) 	# $t1 = num
			slt		$t2, $t0, $t1	# if n < num t2 = 1 else t2 = 0
			beq		$t2, $0, endbin_loop1			

			lw		$t2, 12($sp) 	# $t2 = rev_bin
			addi	$t3, $0, 4 		# $t3 = 4
			mult	$t3, $t0
			mflo	$t4				# $t4 = n*4
			add		$t4, $t4, $t3	# $t4 = n*4 + 4
			add		$t4, $t4, $t2	# $t4 = n*4 + 4 + rev_bin
			sw		$0, ($t4)		# rev_bin[n] = 0

			addi	$t0, $t0, 1		# $t0 = n + 1
			sw		$t0, ($sp) 		# n += 1

			j		bin_loop1

endbin_loop1:

		# aux = num
			lw 		$t0, 8($fp) 	
			sw 		$t0, 8($sp)

bin_loop2:	lw 		$t0, 8($sp) 	# $t0 = aux
			addi 	$t1, $0, 1 		# $t1 = 1
			blt 	$t0, $t1, endbin_loop2 

			sw 		$0, 4($sp) 		# i = 0

bin_loop3: 	lw 		$t0, 4($sp) 	# $t0 = i
			addi 	$t1, $0, 0 		# $t0 = 0
			addi 	$t2, $0, 2 		# $t2 = 2
			addi 	$t3, $0, 1 		# $t3 = 1

		# 2 ** i
bin_loop4:	beq 	$t0, $t1, endbin_loop4
			
			mul 	$t3, $t3, $t2 	# $t3 = $t3 * 2
			addi 	$t1, $t1, 1 	# $t1 += 1

			j 		bin_loop4

endbin_loop4:
			lw 		$t0, 8($sp) 	# $t0 = aux
			bgt 	$t3, $t0, endbin_loop3

			lw 		$t1, 4($sp) 	# $t1 = i
			addi 	$t1, $t1, 1 	# $t1 = i + 1
			sw 		$t1, 4($sp)  	# i += 1

			j 		bin_loop3

endbin_loop3:
			sub 	$t1, $t1, 1 	# $t1 = i - 1
			sw 		$t1, 4($sp) 	# i -= 1

			lw		$t2, 12($sp)  	# $t2 = rev_bin
			addi	$t6, $0, 4 		# $t6 = 4
			mult	$t6, $t1		
			mflo	$t4		 		# $t4 = i*4
			add		$t4, $t4, $t6	# $t4 = i*4 + 4
			add		$t4, $t4, $t2	# $t4 = i*4 + 4 + rev_bin
			addi 	$t5, $0, 1 		# $t5 = 1
			sw		$t5, ($t4)		# rev_bin[i] = 1
		
			lw 		$t0, 4($sp) 	# $t0 = i
			addi 	$t1, $0, 0 		# $t1 = 0
			addi 	$t2, $0, 2 		# $t2 = 2
			addi 	$t3, $0, 1 		# $t3 = 1

		# 2 ** i
bin_loop6:	beq 	$t0, $t1, endbin_loop6
			
			mul 	$t3, $t3, $t2 	# $t3 = $t3 * 2
			addi 	$t1, $t1, 1 	# $t1 += 1

			j 		bin_loop6

endbin_loop6:
			lw 		$t0, 8($sp)		# $t0 = aux 
			sub 	$t0, $t0, $t3	# aux -= 2**i
			sw 		$t0, 8($sp)		# aux = $t0 

			j 		bin_loop2 

endbin_loop2:		

bin_loop5: 		
		# find last item in list
			lw 		$t3, 12($sp) 	# $t3 = rev_bin
			lw		$t0, ($t3)		# $t0 = size
			addi	$t1, $0, 4 		# $t1 = 4
			mult	$t1, $t0 
			mflo	$t2 			# $t2 = 4*size
			add	$t2, $t2, $t1		# $t2 = 4*size + 4
			add 	$t2, $t2, $t3 	# $t2 = 4*size + 4 + rev_bin

			lw 		$t1, ($t2) 		# $t1 = rev_bin[size]
			bne 	$0, $t1, endbin_loop5

			sub		$t0, $t0, 1 	# $t0 = size - 1
			sw		$t0, ($t3)		# size - = 1
			
			j 	bin_loop5

endbin_loop5: 	
			addi	$t0, $t0, 1 	# $t0 = 1
			sw		$t0, ($t3)		# size = 1
			
			sub 	$sp, $sp, 4 	# allocates space for argument
			sw 		$t3, ($sp) 		# passes rev_bin as argument

			jal 	reverse

			addi 	$sp, $sp, 4 	# clears space for arguments

			lw 		$v0, 12($sp) 	# $v0 = rev_bin

			addi 	$sp, $sp, 16 	# clears local variables off stack

		# restores $fp and $ra and returns
			lw 		$fp, ($sp)
			lw 		$ra, 4($sp)
			addi 	$sp, $sp, 8
			jr 		$ra

# @param: list to be put in reverse order
# @pre: swap() is defined
# @post: list is in reverse order
# @complexity: best and wort case are the same: O(N)

# memory map:
 
# n
# size
# old fp
# ra
# the_list

reverse: # stores fp, ra, sets new fp
			addi 	$sp, $sp, -8
			sw 		$ra, 4($sp)
			sw 		$fp, ($sp)
			addi 	$fp, $sp, 0

			addi 	$sp, $sp, -8 	# allocates local variables on stack

			sw 		$0, ($sp) 		# n = 0

			lw 		$t0, 8($fp) 	# $t0 = the_list
			lw		$t1, ($t0) 		# $t1 = size
			sw 		$t1, 4($sp)		# stores size on stack
			div 	$t1, $t1, 2 	# $t1 = size/2

loop_rev: # if n >= size/2 goto return
			lw		$t0, ($sp)		# $t0 = n
			slt		$t2, $t0, $t1	# if n < size/2 t2 = 1 else t2 = 0
			beq		$t2, $0, return
			
		# stores temporary registers
			sw 		$t0, -4($sp) 	
			sw 		$t1, -8($sp)

		# passes arguments on stack
			lw 		$t2, 8($fp) 	# $t2 = the_list
			sw 		$t2, -12($sp) 	# passes the_list as argument
			sw 		$t0, -16($sp) 	# passes n as argument
			lw 		$t2, 4($sp) 	# $t2 = size
			sub 	$t2, $t2, $t0 	# $t2 = size - n
			sub 	$t2, $t2, 1 	# $t2 = size - n - 1
			sw 		$t2, -20($sp) 	# passes size - n - 1 as argument

		#updates $sp
			sub 	$sp, $sp, 20 	# $sp = $sp -20

			jal 	swap

		# clears arguments off stack
			addi 	$sp, $sp, 12 

		# restores temporary register values
			lw 		$t1, ($sp) 	  	# $t1 = size/2
			lw		$t0, 4($sp) 	# $t0 = n
			addi 	$sp, $sp, 8

			addi	$t0, $t0, 1		# $t0 = n + 1
			sw		$t0, ($sp) 		# n += 1

			j 		loop_rev

return:		
			addi 	$sp, $sp, 8 	# clears local variables off stack

		# restore $fp and $ra
			lw 		$fp, ($sp)
			lw 		$ra, 4($sp)
			addi 	$sp, $sp, 8
			jr 		$ra

# @param: list, and position of items to be swaped
# @pre: none
# @post: list has the two items swaped
# @complexity: best and worst case are the same: O(1)

# memory map:

# temp
# fp
# ra
# pos2
# pos1
# the_list

swap: 	# stores $fp and $ra and updtes $fp	
			addi 	$sp, $sp, -8
			sw 		$ra, 4($sp)
			sw 		$fp, ($sp)
			addi 	$fp, $sp, 0

		# allocates local variables on stack
			addi 	$sp, $sp, -4 

			lw 		$t0, 16($fp) 	# $t0 = the_list
			lw 		$t1, 12($fp)	# $t1 = pos1
			addi	$t2, $0, 4 		# $t2 = 4
			mult	$t1, $t2
			mflo 	$t1 			# $t1 = pos1*4
			add 	$t1, $t1, $t2 	# $t1 = pos1*4 + 4
			add 	$t1, $t1, $t0 	# $t1 = pos1*4 + 4 + (the_list)

			lw		$t3, ($t1) 		# $t3 = the_list[pos1]
			sw 		$t3, ($sp)		# temp = the_list[pos1]

			lw 		$t3, 8($fp)		# $t3 =  pos2
			mult	$t3, $t2
			mflo 	$t3 			# $t3 = pos2*4
			add 	$t3, $t3, $t2 	# $t3 = pos2*4 + 4
			add 	$t3, $t3, $t0 	# $t3 = pos2*4 + 4 + (the_list)

			lw 		$t4, ($t3) 		# $t4 = the_list[pos2]
			sw 		$t4, ($t1) 		# the_list[pos1] = the_list[pos2]

			lw 		$t4, ($sp) 		# $t4 = the_list[pos1]
			sw 		$t4, ($t3)		# the_list[pos2] = the_list[pos1]

			addi 	$sp, $sp, 4 	# clears local variables off stack

		# restores $fp and $ra
			lw 		$fp, ($sp)
			lw 		$ra, 4($sp)
			addi 	$sp, $sp, 8
			jr 		$ra
