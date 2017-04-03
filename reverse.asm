# @author Gabriela Melo
# @since 08/04/2015
# @modified 17/04/2015

# test cases
# input: [1,2,3,4]
# expected output: [4,3,2,1]
# actual output: [4,3,2,1]
# input: [1,2,3,4,5]
# expected output: [5,4,3,2,1]
# actual output: [5,4,3,2,1]

			.data
prompt1: 	.asciiz "Enter size of list: "
prompt2:	.asciiz "Enter next item of list: "
size: 		.word	0
the_list:	.word 	0
i: 			.word 	0

			.text
			
		# size = int(input("Enter size of list: "))
			la		$a0, prompt1	# print prompt1
			addi	$v0, $0, 4
			syscall
		
			addi	$v0, $0, 5		# read size
			syscall
			sw		$v0, size
		
		# the_list.append(int(input("Enter next item of list: ")))
			lw		$t0, size		# allocate memory to store list
			addi	$t1, $0, 4
			mult	$t1, $t0
			mflo	$t2
			add		$a0, $t2, $t1	# a0 = 4*size + 4
			addi	$v0, $0, 9
			syscall

			sw		$v0, the_list	# the_list points to allocated memory
			sw		$t0, ($v0)		# the size of the list is put at the start of the allocated memory
				
			sw 		$0, i 			# i = 0
			lw		$t2, the_list	# $t2 = the_list
			addi	$t3, $0, 4 		# $t3 = 4
		
loop:	# if i >= size goto endloop	
			lw		$t0, i			# $t0 = i
			lw		$t1, size 		# $t1 = size
			slt		$t5, $t0, $t1	# if i < size $t5 = 1 else $t5 = 0
			beq		$t5, $0, endloop
		
			la		$a0, prompt2	# print prompt2
			addi	$v0, $0, 4
			syscall
			
			addi	$v0, $0, 5	# read next value
			syscall

			mult	$t3, $t0 		
			mflo	$t4				# $t4 = i*4
			add		$t4, $t4, $t3	# $t4 = i*4 + 4
			add 	$t4, $t4, $t2 	# $t4 = i*4 + 4 + the_list
			sw		$v0, ($t4)		# the_list[i] = input
		
			addi	$t0, $t0, 1		# $t0 = i + 1
			sw		$t0, i 			# i += 1
		
			j		loop

		
endloop: # reverse(the_list)	
			addi 	$sp, $sp, -4 	# allocates space for arguments
			lw 		$t0, the_list 	# $t0 = the_list
			sw 		$t0, ($sp) 		# passes the_list as argument
			
call:		jal 	reverse
			
			addi 	$sp, $sp, 4 	# clears arguments off stack 

		# print(the_list)		
			sw 		$0, i 			# i = 0
			lw		$t2, the_list 	# $t2 = the_list
			addi	$t3, $0, 4 		# $t3 = 4
		
loop3:	# if i >= size goto exit
			lw		$t0, i			# $t0 = i	
			lw		$t1, size 		# $t1 = size
			slt		$t5, $t0, $t1	# if i < size t5 = 1 else t5 = 0
			beq		$t5, $0, exit
		
			mult	$t3, $t0 		
			mflo	$t4				# $t4 = i*4
			add		$t4, $t4, $t3	# $t4 = i*4 + 4
			add		$t4, $t4, $t2	# t4 = i*4 + 4 + the_list
			lw		$a0, ($t4)		# $a0 = the_list[i]
			addi	$v0, $0, 1		# print(the_list[i])
			syscall
		
			addi	$t0, $t0, 1		# $t0 = i + 1
			sw		$t0, i 			# i += 1
		
			j		loop3
		
exit:		addi	$v0, $0, 10		# exit
			syscall 


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