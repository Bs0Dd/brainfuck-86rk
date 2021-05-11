        ; kr580vm80a assembler code for radio-86rk (32kb)
exit    equ 0F86Ch
print   equ 0F818h
getch   equ 0F803h
setch   equ 0F809h
sethex  equ 0F815h

	org 0h
	lxi hl, title
	call print
	lxi hl, 1457h
clmem:	
	inx hl
	mvi m, 0
	mov a, h
	cpi 75h
	jnz clmem
	mov a, l
	cpi 0FFh
	jnz clmem

	lxi hl, panke
	call print
	call getch
	mvi c, 1Fh
	call setch
	lxi hl, 1458h
	lxi de, 199h
	lxi bc, 0
loop:
	inx de
	xchg
	mov a, m
	xchg
	cpi 0
	jz exit
	cpi '>'
	cz next
	cpi '<'
	cz prev
	cpi '+'
	cz incr
	cpi '-'
	cz decr
	cpi '.'
	cz syout
	cpi ','
	cz syin
	cpi '['
	cz cycbeg
	cpi ']'
	cz cycend
	jmp loop
	
next:
	inx hl
	mvi a, 76h
	cmp h
	jz memerr
	ret

prev:
	dcx hl
	mvi a, 14h
	cmp h
	rnz
	mvi a, 57h
	cmp l
	rnz
memerr:
	call outhex
	lxi hl, errme
	call print
	jmp exit

incr:
	inr m
	ret

decr:
	dcr m
	ret

syout:
	mov c, m
	call setch
	ret

syin:
	push hl
	lxi hl, crlf
	call print
	mvi c, '>'
	call setch
	call getch
	mov c, a
	push bc
	call setch
	lxi hl, crlf
	call print
	pop bc	
	pop hl
	mov m, c
	ret

cycbeg:
	mov a, m
	cpi 0
	mvi a, 1
	rnz
beglop:
	cpi 0
	rz
	mov b, a
	inx de
	xchg
	mov a, m
	xchg
	cpi '['
	cz incrc
	cpi ']'
	cz decrc
	cpi 0
	cz noend
	mov a, b
	jmp beglop

cycend:
	mov a, m
	cpi 0
	mvi a, 1
	rz
endlop:
	cpi 0
	rz
	mov b, a
	dcx de
	xchg
	mov a, m
	xchg
	cpi '['
	cz decrc
	cpi ']'
	cz incrc
	cpi 0
	cz nobeg
	mov a, b
	jmp endlop	

incrc:
	inr b 
	ret

decrc:
	dcr b
	ret

outhex:
	lxi hl, crlf
	call print 
	mov a, d
	call sethex
	mov a, e
	call sethex
	lxi hl, err
	call print
	ret

nobeg:
	call outhex
	lxi hl, errcyc
	call print
	mvi c, '['
	call setch
	jmp exit
	
noend:
	call outhex
	lxi hl, errcyc
	call print
	mvi c, ']'
	call setch
	jmp exit

crlf:
	db 0dh,0ah,0

title:
	db 1fh,'ispolnitelx qzyka BRAINFUCK',0dh,0ah
	db 'wersiq 1.4p',0dh,0ah,0ah,0

err:
	db ':o{ibka - ',7,0

errcyc:
	db 'ovidalsq ',0

errme:	
	db 'wyhod za predely pamqti',0

panke:
	db 'navmite l`bu` klawi{u',0dh,0ah,0