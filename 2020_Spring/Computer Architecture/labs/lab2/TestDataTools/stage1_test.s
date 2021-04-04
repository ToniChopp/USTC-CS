.org 0x0
    .global _start
_start:

main:
	li		gp,1 #test:slli
	li 		t0,1	
	li 		t1,8
	nop
	nop
	slli 	t0,t0,3 #t0 = 8
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,2 #test:srai
	li 		t0,-1	
	li 		t1,-1
	nop
	nop
	srai 	t0,t0,3 #t0 = -1
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,3 #test:srli
	li 		t0,4	
	li 		t1,1
	nop
	nop
	srli 	t0,t0,2 #t0 = 1
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,4 #test:add
	li 		t0,1	
	li 		t1,8
	li		t2,-7
	nop
	nop
	add 	t1,t1,t2 #t1 = 1
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,5 #test:sub
	li 		t0,1	
	li 		t1,8
	li		t2,-7
	nop
	nop
	add 	t1,t1,t2 #t1 = 1
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,6 #test:sll
	li 		t0,1	
	li 		t1,8
	li		t2,3
	nop
	nop
	sll 	t0,t0,t2 #t0 = 8
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,7 #test:slt
	li 		t0,1	
	li 		t1,-1
	nop
	nop
	slt 	t2,t0,t1 #t2 = 0
	nop
	nop
	beq		t0,t2,fail
	nop
	nop
	li		gp,8 #test:sltu
	li 		t0,1	
	li 		t1,-1
	nop
	nop
	sltu 	t2,t0,t1 #t2 = 1
	nop
	nop
	bne		t0,t2,fail
	nop
	nop
	li		gp,9 #test:xor
	li 		t0,0x0f	
	li 		t1,0x0f
	li		t2,0
	nop
	nop
	xor		t0,t0,t1 #t0 = 0
	nop
	nop
	bne		t0,t2,fail
	nop
	nop
	li		gp,10 #test:srl
	li 		t0,1	
	li 		t1,8
	li		t2,3
	nop
	nop
	srl 	t1,t1,t2 #t1 = 1
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,11 #test:sra
	li 		t0,-1	
	li 		t1,-7
	li		t2,3
	nop
	nop
	sra		t1,t1,t2 #t1 = 1
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,12 #test:or
	li 		t0,0x0f	
	li 		t1,0x0f0
	li		t2,0x0ff
	nop
	nop
	or 		t0,t0,t1 #t0 = 0x0ff
	nop
	nop
	bne		t0,t2,fail
	nop
	nop
	li		gp,13 #test:and
	li 		t0,0x0f	
	li 		t1,0x0f1
	li		t2,1
	nop
	nop
	and		t0,t0,t1 #t0 = 1
	nop
	nop
	bne		t0,t2,fail
	nop
	nop
	li		gp,14 #test:addi
	li 		t0,1	
	li 		t1,8
	nop
	nop
	addi 	t0,t0,7 #t0 = 8
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,15 #test:slti
	li 		t0,1	
	li 		t1,0
	nop
	nop
	slti 	t0,t0,-1 #t0 = 0
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,16 #test:sltiu
	li 		t0,1	
	li 		t1,1
	nop
	nop
	sltiu 	t0,t0,-1 #t0 = 1
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,17 #test:xori
	li 		t0,0x0f	
	li 		t1,0x0ff
	nop
	nop
	xori 	t0,t0,0x0f0 #t0 = 0x0ff
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,18 #test:ori
	li 		t0,0x0f	
	li 		t1,0x0ff
	nop
	nop
	ori 	t0,t0,0x0f0 #t0 = 0x0ff
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,19 #test:andi
	li 		t0,0x0ff	
	li 		t1,0
	nop
	nop
	andi 	t0,t0,0 #t0 = 0x0
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,20 #test:lui
	lui 	t0,0xfffff #t0 = 0xfffff000	
	li 		t1,0xfffff000
	nop
	nop
	bne		t0,t1,fail
	nop
	nop
	li		gp,21 #test:auipc
	auipc 	t0,0 #t0 = current pc
	auipc	t1,0 #t1 = lastpc +4
	nop
	nop
	add		t1,t1,-4
	nop
	nop
	bne		t0,t1,fail
	nop
	nop

success:
	li 		gp,22 #finish
	j		success

fail:
	li 		gp,-1 #fail
	j		fail