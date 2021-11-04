
 .text 

 main: 
 lui t0,42949 # 0.1 in 32,32
 lui t6 6729
 li t1,0
 li t4,4
 
 loop:
 slli t3,t1,2 
 add t3,t2,t3 
 lw t3,0(t3) 
 add t0,t0,t3 
 addi t1,t1,1 
 blt t1,t4,loop
 
 #li a7,5 
 #ecall
 #add t0,t0,a0
 #bne a0,zero,loop
 
 done:
 li t0, 8 #read input string from user
 li a1, 20 #allocate space for the string


