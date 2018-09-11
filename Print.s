; Print.s
; Student names: change this to your names or look very silly
; Last modification date: change this to the last modification date or look very silly
; Runs on LM4F120 or TM4C123
; EE319K lab 7 device driver for any LCD
;
; As part of Lab 7, students need to implement these LCD_OutDec and LCD_OutFix
; This driver assumes two low-level LCD functions
; ST7735_OutChar   outputs a single 8-bit ASCII character
; ST7735_OutString outputs a null-terminated string 

    IMPORT   ST7735_OutChar
    IMPORT   ST7735_OutString
    EXPORT   LCD_OutDec
    EXPORT   LCD_OutFix

    AREA    |.text|, CODE, READONLY, ALIGN=2
    THUMB

DEC EQU 0
COUNT EQU 4

INT0 EQU 4	;LSB
INT1 EQU 8
INT2 EQU 12
INT3 EQU 16	;MSB

  

;-----------------------LCD_OutDec-----------------------
; Output a 32-bit number in unsigned decimal format
; Input: R0 (call by value) 32-bit unsigned number
; Output: none
; Invariables: This function must not permanently modify registers R4 to R11
LCD_OutDec

	SUB SP, SP, #8
	
	
	STR R0, [SP, #DEC]
	MOV R1, #0
	STR R1, [SP, #COUNT]
	
	
	
; count how many times a character needs to be printed
countloop
	LDR R1, [SP, #COUNT]
	ADD R1, #1
	STR R1, [SP, #COUNT]
	MOV R2, #10
	UDIV R0, R0, R2
	CMP R0, #0
	BNE countloop
	
	
	
	
	
;print next character
nextChar
	LDR R1, [SP, #COUNT]
	SUB R1, #1
	STR R1, [SP, #COUNT]
	ADD R2, R1, #0
	MOV R3, #1	;R3 will be what DEC needs to be divided by
	
;get number by which DEC neets to be divided
loopExp
	CMP R2, #0
	BEQ endexp
	SUB R2, #1
	MOV R0, #10
	MUL R3, R3, R0
	B loopExp
endexp
	LDR R0, [SP, #DEC]
	UDIV R0, R0, R3
	ADD R0, #0x30
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}
	
	SUB R0, #0x30
	MUL R0, R3
	LDR R2, [SP, #DEC]
	SUB R2, R0
	STR R2, [SP, #DEC]
	
	LDR R1, [SP, #COUNT]
	CMP R1, #0
	BEQ done
	B nextChar
	

done
	ADD SP, SP, #8


    BX  LR
;* * * * * * * * End of LCD_OutDec * * * * * * * *

; -----------------------LCD _OutFix----------------------
; Output characters to LCD display in fixed-point format
; unsigned decimal, resolution 0.001, range 0.000 to 9.999
; Inputs:  R0 is an unsigned 32-bit number
; Outputs: none
; E.g., R0=0,    then output "0.000 "
;       R0=3,    then output "0.003 "
;       R0=89,   then output "0.089 "
;       R0=123,  then output "0.123 "
;       R0=9999, then output "9.999 "
;       R0>9999, then output "*.*** "
; Invariables: This function must not permanently modify registers R4 to R11
LCD_OutFix

	;if R0>9999, print *.***
	MOV R1, #303
	MOV R2, #33
	MOV R3, R0	;store input in R3
	MUL R1, R1, R2
	CMP R0, R1
	BLS nextOut
	MOV R0, #0x2A
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}
	MOV R0, #0x2E
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}
	MOV R0, #0x2A
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}
	MOV R0, #0x2A
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}
	MOV R0, #0x2A
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}
	BX LR
	
	
	
nextOut
	MOV R0, R3 ;restore input into R0
	SUB SP, #24
	
	STR R0, [SP, #DEC]
	MOV R1, #1000
	UDIV R0, R1
	STR R0, [SP, #INT3]
	MUL R0, R1
	LDR R2, [SP, #DEC]
	SUB R2, R0
	STR R2, [SP, #DEC]
	MOV R1, #100
	UDIV R2, R1
	STR R2, [SP, #INT2]
	MUL R2, R1
	LDR R0, [SP, #DEC]
	SUB R0, R2
	STR R0, [SP, #DEC]
	MOV R1, #10
	UDIV R0, R1
	STR R0, [SP, #INT1]
	MUL R0, R1
	LDR R2, [SP, #DEC]
	SUB R2, R0
	STR R2, [SP, #INT0]
	
	
	LDR R0, [SP, #INT3]
	ADD R0, #0x30
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}
	
	MOV R0, #0x2E
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}
	
	LDR R0, [SP, #INT2]
	ADD R0, #0x30
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}
	
	LDR R0, [SP, #INT1]
	ADD R0, #0x30
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}
	
	LDR R0, [SP, #INT0]
	ADD R0, #0x30
	PUSH {R0, R1, R2, R3, R4, LR}
	BL ST7735_OutChar	;output char
	POP {R0, R1, R2, R3, R4, LR}

	
	
	ADD SP, #24

    BX   LR
 
    ALIGN
;* * * * * * * * End of LCD_OutFix * * * * * * * *

    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file
