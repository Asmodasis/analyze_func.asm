;===============================================================================
;
; FILE:              analyze_func.asm
;
; ASSEMBLY:         nasm -f elf analyze_func.asm
; TO LINK:	    ld -m elf_i386 -s -o analyze_func analyze_func.o cs219_io.o
; MAKE:		    To make, type "make", to clean, "make clean"
;			clean will remove objects generated only for this file. 
; TO RUN:	    ./analyze_func

; DESCRIPTION:       Takes input of a polynomial, evaluates the polynomial at
;                      an x value and finds its derivative and evaluates that
;                      at the x value as well.
;
; INPUT:	    A polynomial
;
; OUTPUT:	    A solved polynomial and its derivative
;
; MODIFICATION HISTORY:
;
; Author                 Date             Version
;================================================================================
; Shawn Ray       	2018-03-31       Version 1.0   started project
; Shawn Ray              2018-03-31       Version 1.1  added variable data for 
;						entries and addes macro for printing
; Shawn Ray              2018-04-01       Version 1.2  began creation of functions
; Shawn Ray              2018-04-02       Version 1.3  debugging
; Shawn Ray              2018-04-04       Version 1.4 	
; Shawn Ray              2018-04-09       Version 1.5  added nwln and exit procedures
; Shawn Ray              2018-04-25       Version 1.6 linked macro, added loops
; Shawn Ray              2018-04-28       Version 1.7 fixed PutStr bug 
; Shawn Ray              2018-04-28       Version 1.8 added get_input
; Shawn Ray              2018-04-28       Version 1.9 added display_f_of_x
; Shawn Ray              2018-04-28       Version 2.0 added display_fp_of_x
; Shawn Ray              2018-04-28       Version 2.1 added eval_f_of_x
; Shawn Ray              2018-04-28       Version 2.2 added eval_fp_of_x
; Shawn Ray              2018-04-29       Version 2.3 fixed bug in eval_f_of_x
; Shawn Ray              2018-04-29       Version 2.4 fixed bug in eval_fp_of_x
;================================================================================

%include "io.mac"
%include "cs219_io.mac"                                              

;##########  Data segment  ######################################################

section .data
	SIZE		:equ 3

	f_of_x		:db 9, 'f(x) = a*x^2 + b*x + c'   , 0 	; string for printing f(x) with linefeed
	
	enter_coef	:db 9, 'Enter coefficient [ ] : ' , 0	; string for entering coef
	enter_x		:db 9, 'Enter input value [x] : ' , 0	
	
	f_disp		:db 9, 'f(x) = '  , 0 , '*x^2 + ' , 0 , '*x + ' , 0
	fp_disp		:db 9, 'f' , 39 , '(x) = ' , 0 , '*x + '   , 0
	
		;; ASCII code 64 for @ shall be my sentinel 
	f_eval		:db 9, 'f(',64,') = '  , 0 , '*(',64,')^2 + ' , 0 , '*(',64,') + ' , 0 
	fp_eval		:db 9, 'f' , 39 , '(',64,') = ' , 0 , '*(',64,') + '   , 0 
	 


;##########  Memory segment  ######################################################

section .bss

	x		:resb 4			; reserves 4 bytes of storage for x varaible
	y		:resb 4			; reserves 4 bytes of storage for y variable
	f_coef		:resd SIZE		
	fp_coef		:resd SIZE - 1		
	chr		:resb 1	 

;##########  Code segment  ######################################################

section .text

 global _start				; entry point for the linker

;=================================================================================
;       Procedure Name: _start
;       Description:    is the main driver procedure for the program
;=================================================================================

 _start:

	
	
	nwln				; prints a newline

	PutStr f_of_x			; put the f(x) str to the screen	
	;; [NOTICE] PutStr requires null terminator 
	
	nwln
	nwln	
	
	call	get_input		; calls the get_input procedure
	
	nwln
	nwln

	call	display_f_of_x		; calls the display_f_of_x procedure
	
	nwln
	
	call	display_fp_of_x		; calls the display_fp_of_x procedure
	
	nwln
	nwln
	
	call	eval_f_of_x		; calls the eval_f_of_x procedure

	nwln
	
	call	eval_fp_of_x		; calls the eval_fp_of_x  procedure

	nwln
	nwln
	
	 exit				; exits the program (stderr = 0)


;=================================================================================
;       Procedure Name: get_input
;       Description:    Read Integers and puts in array
;	Notes:		Get_x is a subprocedure of this procedure.
;=================================================================================

 get_input:
	mov	[chr], byte  96		; ASCII value for letter character
	
	mov	EBX, f_coef		; store array address to register EBX
	mov	ECX, SIZE		; store array size to register ECX
 
 array_loop:
	
	inc	byte [chr]		; increment character's ASCII value
	mov	AL, [chr]		; write character to prompt1[15]
	mov	[enter_coef + 20], AL	; write character to prompt1[15]
	PutStr enter_coef		; request input value
	GetLInt EAX			; read long integer
	mov	[EBX], EAX		; copy value into array
	add	EBX, 4			; increment array address
	loop	array_loop		; iterates a maximum of SIZE
	
	cmp ECX, 0			; if count == 0, get x
	 je get_x
	
  get_x:
	xor ebx, ebx			; clear reg(ebx)
	mov ebx, x			; load memory for x into reg(ebx)
	
        PutStr enter_x	              	; request x value


	GetLInt eax			; get LInt and store into reg(eax)
	mov [ebx], eax
		
	 ret				; return to _start


;=================================================================================
;       Procedure Name: display_f_of_x
;       Description:    displays the function with the input coefs
;=================================================================================

 display_f_of_x:

					; display the function
	show_array f_disp , f_coef, SIZE
	
	
	 ret				; return to _start

;=================================================================================
;       Procedure Name: display_fp_of_x
;       Description:    displays the functions derivative 
;=================================================================================

 display_fp_of_x:
	
	mov ebx, f_coef			; store address of f_coef in mem(ebx)
	mov ecx, fp_coef		; store address of fp_coef in mem(ecx)
	
	mov eax, 2			; move 2 into reg(eax)
	mul dword [ebx]			; reg(eax) = reg(ebx) * reg(eax)
	mov [ecx], eax			; mov contents to reg(ecx)
	add ebx, 4			; increment mem(ebx) to next location
	add ecx, 4			; increment mem(ecx) to next location
	mov eax, [ebx]			; temp location for transfer b
	mov [ecx], eax			; fp_coef


					; show the derivative
	show_array fp_disp , fp_coef, SIZE - 1
	
	 ret				; return to _start

;=================================================================================
;       Procedure Name: eval_f_of_x
;       Description:    evaluates the derivative at the x value and displays it
;=================================================================================

 eval_f_of_x:
	
	mov ecx, f_coef			; store address of f_coef in mem(ecx)
	mov eax, [x]			; store value of x in reg(eax)
	mov ebx, 0


	mul eax				; reg(eax) = x^2
	mul dword [ecx]			; reg(eax) = a*x^2

	add ebx, eax			; reg(ebx) = a*x^2
	add ecx, 4			; increment to next word

	mov eax, [x]			; store value of x in reg(eax)

	mov edx, [ecx]			; load the next coef into reg(edx)

	mul edx				; reg(eax) = reg(eax) * reg(edx)

	add ebx, eax			;reg(ebx) = reg(ebx) + reg(eax)

	add ecx, 4			; increment to the next word
	
	add ebx, [ecx]			; add the next
	
	xor edx, edx			; clear out reg(edx)
	mov edx, y			; store address of y in mem(edx)
	mov [edx], ebx			; move the result into reg(edx)

					;show the function at x
	show_func f_eval, f_coef, SIZE, [x]


        PutCh ' '			; display a space
	PutCh '='			; display an =
	PutCh ' '			; display a space

	xor eax, eax			; clear out reg(eax)
	mov eax, [y]			; move the value from y for printing
	
	PutLInt eax			; print y
 
	ret				; return to _start

;=================================================================================
;       Procedure Name: eval_fp_of_x
;       Description:    evaluates the derivative at the x value and displays it
;=================================================================================


 eval_fp_of_x:

	mov ecx, fp_coef                ; store address of fp_coef in mem(ecx)
	mov eax, [x]			;
	mov ebx, [ecx]			; load value into reg(eax)


	mul ebx				; reg(eax) = reg(eax) * reg(ebx)

	add ecx, 4			; increment to the next word
	mov ebx, [ecx]                  ; load value into reg(eax)
	
	add eax, ebx			; reg(eax) = reg(eax) + reg(ebx)
	
	xor edx, edx			; clear our reg(edx)
        mov edx, y			; store address of y in mem(edx)
 
        mov [edx], eax			; store value from reg(eax) to reg(edx)

				; show the derivative at x
	show_func2 fp_eval, fp_coef, SIZE - 1, [x]

	
	PutCh ' '                       ; display a space
        PutCh '='                       ; display an =
        PutCh ' '                       ; display a space

	PutLInt [y]			; print y 


	 ret				; return to _start



