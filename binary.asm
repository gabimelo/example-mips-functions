# @author Gabriela Melo
# @since 08/04/2015
# @modified 17/04/2015

# test cases

# input: 12
# expected output: 1100
# actual output: 1100
# input: 3
# expected output: 11 
# actual output: 11
# input: 16
# expected output: 10000 
# actual output:  10000 

			.data
prompt1: 	.asciiz "Enter positive integer: "
num: 		.word	0
bin: 		.word 	0
i: 		.word 	0

			.text
			
		# num = int(input("Enter positive integer: "))
			la		$a0, prompt1	# print prompt1
			addi	$v0, $0, 4
			syscall
		
			addi	$v0, $0, 5		# read num
			syscall
			sw		$v0, num

		# bin = binary(num)
			addi 	$sp, $sp, -4 	# pass num as argument
			lw 		$t0, num
			sw 		$t0, ($sp)

			jal 	binary

			addi 	$sp, $sp, 4 	# clear arguments off stack

			sw 		$v0, bin

		#print(bin)
			sw		$0, i			# i = 0
loop:	# if i >= size goto exit	
			lw		$t0, i			# $t0 = i
			lw 		$t5, bin 		# $t5 = bin
			lw		$t1, ($t5) 		# $t1 = size of bin
			slt		$t2, $t0, $t1	# if i < size t2 = 1 else t2 = 0
			beq		$t2, $0, exit
		
			lw		$t2, bin 		# $t2 = bin
			addi	$t3, $0, 4 		# $t3 = 4
			mult	$t3, $t0 		
			mflo	$t4				# $t4 = i*4
			add		$t4, $t4, $t3	# $t4 = i*4 + 4
			add		$t4, $t4, $t2	# $t4 = i*4 + 4 + bin
			lw		$a0, ($t4)		# $a0 = bin[i]
			addi	$v0, $0, 1		# print(bin[i])
			syscall
		
			addi	$t0, $t0, 1		# $t0 = i + 1
			sw		$t0, i 			# i += 1
		
			j		loop
		
exit:
			addi	$v0, $0, 10	# exit
			syscall 


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