# @author Gabriela Melo
# @since 08/04/2015
# @modified 17/04/2015

# test cases:

# input: 5 [5,4,3,2,1]
# expected output: [1,2,3,4,5]
# actual output: [1,2,3,4,5]
# input: 4 [1,2,3,4]
# expected output: [1,2,3,4] 
# actual output: [1,2,3,4]

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
			lw		$t0, size		# allocate enough memory to store list
			addi	$t1, $0, 4
			mult	$t1, $t0
			mflo	$t2
			add		$a0, $t2, $t1	# a0 = 4*size + 4
			addi	$v0, $0, 9
			syscall

			sw		$v0, the_list	# the_list points to the allocated memory
			sw		$t0, ($v0)		# the size of the list is put at the start of the allocated memory
				
			sw 		$0, i 			# i = 0
			lw		$t2, the_list
			addi	$t3, $0, 4
		
loop:		lw		$t0, i			# if i >= size goto endloop
			lw		$t1, size
			slt		$t5, $t0, $t1	# if i < size t5 = 1 else t5 = 0
			beq		$t5, $0, endloop
		
			la		$a0, prompt2	# print prompt2
			addi	$v0, $0, 4
			syscall
			
			addi	$v0, $0, 5	# read next value
			syscall

			mult	$t3, $t0
			mflo	$t4		
			add		$t4, $t4, $t3	# t4 = i*4 + 4
			add 	$t4, $t4, $t2 	
			sw		$v0, ($t4)		# store the next value
		
			addi	$t0, $t0, 1		# i = i + 1
			sw		$t0, i
		
			j		loop

		# bubble_sort(the_list)
endloop:	addi 	$sp, $sp, -4
			lw 		$t0, the_list
			sw 		$t0, ($sp) 		# stores address to the_list on stack
			
call:		jal 	bubble_sort
			
			addi 	$sp, $sp, 4 	# clears arguments off stack 

		# print(the_list)		
			sw 		$0, i 			# i = 1
			lw		$t2, the_list
			addi	$t3, $0, 4
		
loop3:		lw		$t0, i			# if i >= size goto exit
			lw		$t1, size
			slt		$t5, $t0, $t1	# if i < size t5 = 1 else t5 = 0
			beq		$t5, $0, exit
		
			mult	$t3, $t0
			mflo	$t4		
			add		$t4, $t4, $t3	# t4 = i*4 + 4
			add		$t4, $t4, $t2	# $t4 points to next location in the list
			lw		$a0, ($t4)		# load the next value
			addi	$v0, $0, 1		# print next value
			syscall
		
			addi	$t0, $t0, 1		# i = i + 1
			sw		$t0, i
		
			j		loop3
		
exit:		addi	$v0, $0, 10		# exit
			syscall 

# @param: list to be sorted
# @pre: swap is defined
# @post: list is sorted
# @complexity: best and worse case are the same: O(N**2)
 
# memory map:

# j
# i
# n
# old fp
# ra
# the_list

bubble_sort: 						# def bubble_sort(the_list):
			addi 	$sp, $sp, -8
			sw 		$ra, 4($sp)
			sw 		$fp, ($sp)
			addi 	$fp, $sp, 0

			addi 	$sp, $sp, -12 	# allocate space for local variables

			lw 		$t0, 8($fp) 	# $t0 = address of the_list
			lw 		$t1, ($t0) 	# $t1 = size of list
			sw 		$t1, -4($fp) 	# n = len(the_list)

			sw 		$0, -8($fp) 	# i = 0

bub_loop1:
			lw 		$t0, -8($fp) 	# $t0 = i
			lw 		$t1, -4($fp) 	# $t1 = n
			addi 		$t1, $t1 ,-1 	# $t1 = n -1
			beq 	$t0, $t1, endbub_loop1

			sw 		$0, -12($fp) 	# j = 0

bub_loop2:
			lw 		$t0, -12($fp) 	# $t0 = j
			lw 		$t1, -4($fp) 	# $t1 = n
			addi 		$t1, $t1 ,-1 	# $t1 = n -1
			beq 	$t0, $t1, endbub_loop2

bub_if: 
			lw 		$t0, 8($fp) 	# $t0 is address of begginning of list
			lw 		$t1, -12($fp) 	# $t1 = j
			addi 	$t2, $0, 4 		# $t2 = 4
			mul 	$t3, $t1, $t2 	# $t3 = j*4
			add 	$t3, $t3, $t2 	# $t3 = j*4 + 4
			add 	$t3, $t3, $t0 	# $t3 = j*4 + 4 + (the_list)
			lw 	$t3, ($t3) 	# $t3 = the_list[j] 

			addi 	$t1, $t1, 1 	# $t1 = j+1
			mul 	$t1, $t1, $t2 	# $t1 = (j+1)*4
			add 	$t1, $t1, $t2 	# $t1 = (j+1)*4 + 4
			add 	$t1, $t1, $t0 	# $t1 = (j+1)*4 + 4 + (the_list)
			lw 	$t1, ($t1) 	# $t1 = the_list[j+1]

		# if the_list[j] > the_list[j+1]:
			bgt 	$t1, $t3, endbub_if
			beq 	$t1, $t3, endbub_if
			
			addi 	$sp, $sp, -12 	# passes arguments on stack
			lw 		$t0, 8($fp) 	# $t0 = the_list
			sw 		$t0, 8($sp) 	# passes the_list as argument
			lw 		$t0, -12($fp) 	# $t0 = j
			sw 		$t0, 4($sp) 	# passes j as argument
			addi 	$t0, $t0, 1 	
			sw 		$t0, ($sp)	# passes j+1 as argument

			jal 	swap  			#  swap(the_list, j, j+1)

			addi 	$sp, $sp, 12 	# clears arguments off stack

endbub_if:
			lw 		$t0, -12($fp) 	# $t0 = j
			addi 	$t0, $t0, 1 	# $t0 = j + 1
			sw 		$t0, -12($fp) 	# j += 1

			j 		bub_loop2
endbub_loop2:
			lw 		$t0, -8($fp) 	# $t0 = i
			addi 	$t0, $t0, 1 	# $t0 = i + 1
			sw 		$t0, -8($fp) 	# i += 1

			j 		bub_loop1

endbub_loop1: 		
			addi	 $sp, $sp, 12 	# clears arguments off stack
			
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