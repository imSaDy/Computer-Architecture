add s0,zero,zero            // s0 = 0
add s1,zero,zero            // s1 = max index x9
add s2,zero,zero            // s2 = 4i 
add s3,zero,zero            // s3 = max value   x19
addi s4,zero,20             // s4 = n
add s5,zero,zero            // s5 = i  21
FOR: beq s5,s4,END_LOOP
    add t3,s2,s0            
    lw t1,0(t3)             // t1 = a[i]
    slt t2,s3,t1
    beq t2,zero,END_IF
    add s3,zero,t1
    add s1,zero,s5          
    END_IF:
    addi s2,s2,4            // s2 = 4i for memaddr
    addi s5,s5,1            // i++
    jal zero,FOR
END_LOOP:



// without comments
add s0,zero,zero            
add s1,zero,zero            
add s2,zero,zero             
add s3,zero,zero            
addi s4,zero,20             
add s5,zero,zero            
FOR: beq s5,s4,END_LOOP
    add t3,s2,s0            
    lw t1,0(t3)             
    slt t2,s3,t1
    beq t2,zero,END_IF
    add s3,zero,t1
    add s1,zero,s5          
    END_IF:
    addi s2,s2,4            
    addi s5,s5,1            
    jal zero,FOR
END_LOOP:
/*
0000000000000000 :
   0:	00000433          	add	s0,zero,zero
   4:	000004b3          	add	s1,zero,zero
   8:	00000933          	add	s2,zero,zero
   c:	000009b3          	add	s3,zero,zero
  10:	01400a13          	li	s4,20
  14:	00000ab3          	add	s5,zero,zero

0000000000000018 :
  18:	034a8463          	beq	s5,s4,40 
  1c:	00890e33          	add	t3,s2,s0
  20:	000e2303          	lw	t1,0(t3)
  24:	0069a3b3          	slt	t2,s3,t1
  28:	00038663          	beqz	t2,34 
  2c:	006009b3          	add	s3,zero,t1
  30:	015004b3          	add	s1,zero,s5

0000000000000034 :
  34:	00490913          	addi	s2,s2,4
  38:	001a8a93          	addi	s5,s5,1
  3c:	fddff06f          	j	18
*/