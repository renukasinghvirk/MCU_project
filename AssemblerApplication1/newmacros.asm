/*
 * newmacros.asm
 *
 *  Created: 27/05/2024 12:47:25
 *   Author: renuka
 */ 

; ==============
;	display macros
; ===============
.macro DISPLAY1 

	call	LCD_init
	ldi	zl, low(2*@0)
	ldi	zh, high(2*@0)
	call	LCD_putstring

.endmacro

.macro DISPLAY2

	call	LCD_init
	ldi	zl, low(2*@0)
	ldi	zh, high(2*@0)
	call	LCD_putstring
	ldi	zl, low(2*@1)
	ldi	zh, high(2*@1)
	ldi	a0, 0x40
	call	LCD_pos
	call	LCD_putstring

.endmacro

; ==============
; 	trivia macros
; ==============

; --- display question and answers as long as answer buttons not pressed

.macro QUESTION ; question: str0, str1 answer: str2, str3, str4, str5
question_start:
display1:
	call	LCD_init
	ldi	zl, low(2*@0)
	ldi	zh, high(2*@0)
	call	LCD_putstring
	ldi	zl, low(2*@1)
	ldi	zh, high(2*@1)
	ldi	a0, 0x40
	call	LCD_pos
	call	LCD_putstring
	call reset_kpd
	call check_reset
	mov b0, a0
	andi a0, 0b10000000
	breq PC+2
	jmp question_end
	cpi b0, 0x48
	brne display1
display2:
	call	LCD_init
	ldi	zl, low(2*@2)
	ldi	zh, high(2*@2)
	call	LCD_putstring
	ldi	zl, low(2*@3)
	ldi	zh, high(2*@3)
	ldi	a0, 0x40
	call	LCD_pos
	call	LCD_putstring
	call reset_kpd
	call check_reset
	mov b0, a0
	andi a0, 0b10000000
	breq PC+2
	jmp question_end
	cpi b0, 0x48
	brne display2
display3:
	call	LCD_init
	ldi	zl, low(2*@4)
	ldi	zh, high(2*@4)
	call	LCD_putstring
	ldi	zl, low(2*@5)
	ldi	zh, high(2*@5)
	ldi	a0, 0x40
	call	LCD_pos
	call	LCD_putstring
	call reset_kpd
	call check_reset
	mov b0, a0
	andi a0, 0b10000000
	breq PC+2
	jmp question_end
	cpi b0, 0x48
	brne display3
	jmp question_start
question_end:
.endmacro

; --- set T in SREG if answer correct
.macro COMPARE
	clt
	ldi zl, low(2*@0)
	ldi zh, high(2*@0)
	lpm
	cp @1, r0
	brne PC+2
	set
.endmacro

; --- print score on LCD as well as fail or pass message
.macro PRINT_SCORE
	call LCD_clear
	brts PC+2
	jmp incorrect
correct:
	DISPLAY1 strcorrect
	CORRECT_SONG
	jmp score
incorrect:
	DISPLAY1 strfalse
	INCORRECT_SONG
score:
	CLR4 a3, a2, a1, a0
	mov a0, @0
	PRINTF LCD
.db "Score:",FDEC,a,0
.endmacro