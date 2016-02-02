#define LCD_LIBONLY
.include "lcd.asm"

.cseg

	call lcd_init			; call lcd_init to Initialize the LCD
	call init_strings

	ldi mainCounter, 0x00
	mainLoop:
		ldi row, 0x00
		ldi col, 0x00

		ldi subCounter, 0x00
		subLoop:
			call display_stringA
			call delay
			call display_stringB
			call delay

			inc row
			inc col
	
			inc subCounter
			cpi subCounter, 0x02
			brne subLoop

		inc mainCounter
		cpi mainCounter, 0x03
		brne mainLoop

	call lcd_clr
	
	ldi row, 0x00
	ldi col, 0x07
	ldi flashCounter, 0x00
	flashLoop:
		
		call display_stringC
		call delay
		call lcd_clr
		call delay

		inc flashCounter
		cpi flashCounter, 0x03
		brne flashLoop

lp:	jmp lp

delay:

	push r20
	push r21
	push r22

	ldi r20, 0x25
del1:	nop
		ldi r21,0xFF
del2:	nop
		ldi r22, 0xFF
del3:	nop
		dec r22
		brne del3
		dec r21
		brne del2
		dec r20
		brne del1	

	pop r22
	pop r21
	pop r20
	ret
	

init_strings:

	push r16
	; copy strings from program memory to data memory
	ldi r16, high(msg1)		; this the destination
	push r16
	ldi r16, low(msg1)
	push r16
	ldi r16, high(msg1_p << 1) ; this is the source
	push r16
	ldi r16, low(msg1_p << 1)
	push r16
	call str_init			; copy from program to data
	pop r16					; remove the parameters from the stack
	pop r16
	pop r16
	pop r16

	ldi r16, high(msg2)
	push r16
	ldi r16, low(msg2)
	push r16
	ldi r16, high(msg2_p << 1)
	push r16
	ldi r16, low(msg2_p << 1)
	push r16
	call str_init
	pop r16
	pop r16
	pop r16
	pop r16

    ldi r16, high(msg3)
	push r16
	ldi r16, low(msg3)
	push r16
	ldi r16, high(msg3_p << 1)
	push r16
	ldi r16, low(msg3_p << 1)
	push r16
	call str_init
	pop r16
	pop r16
	pop r16
	pop r16

	pop r16
	ret

display_stringA:

	push r16
	call lcd_clr

	mov r16, row
	push r16
	mov r16, col
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	ldi r16, high(msg1)
	push r16
	ldi r16, low(msg1)
	push r16
	call lcd_puts
	pop r16
	pop r16

	pop r16
	ret

display_stringB:

	push r16
	call lcd_clr

	mov r16, row
	push r16
	mov r16, col
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	ldi r16, high(msg2)
	push r16
	ldi r16, low(msg2)
	push r16
	call lcd_puts
	pop r16
	pop r16

	pop r16
	ret

display_stringC:

	push r16
	call lcd_clr

	mov r16, row
	push r16
	mov r16, col
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	ldi r16, high(msg3)
	push r16
	ldi r16, low(msg3)
	push r16
	call lcd_puts
	pop r16
	pop r16

	pop r16
	ret

msg1_p:	.db "Harrison W", 0	
msg2_p: .db "CSC 230!", 0
msg3_p: .db "A", 0

.dseg

msg1:	.byte 200
msg2:	.byte 200
msg3:	.byte 200
line1: .byte 17
line2: .byte 17

.def mainCounter = r16
.def subCounter = r17
.def flashCounter = r18
.def row = r19
.def col = r20
