; COAL Lab Project
; Rayyan Aamir | Usaid Khan | Syed M. Furqan
INCLUDE Irvine32.inc

.data
	; Startup MsgBox Message
	titleMsg BYTE "COAL Project - Assembly x86",0
	welcomeMsg BYTE "Welcome to Student Record System!",13,10,13,10,
               "Developed by:",13,10,
               "Rayyan Aamir (24K-0687)",13,10,
               "Usaid Khan (24K-0832)",13,10,
               "Syed M. Furqan (24K-0766)",0

	; Admin Menu Message
	menuMsg BYTE "-----------------------------",13,10,
			"STUDENT RECORD SYSTEM",13,10,
			"ADMIN MODULE",13,10,
			"-----------------------------",13,10,
			"1. Sign In",13,10,
			"2. Create New Account",13,10,
			"3. Exit Program",13,10,
			"Enter your choice: ",0

	exitMsg BYTE "Thank you for using Student Record System!",0

.code
main PROC
startup:
	mov ebx, OFFSET titleMsg
	mov edx, OFFSET welcomeMsg
	call MsgBox

admin_menu:
	call Clrscr
	call CRLF

	; mov eax, 14 + (1 * 16)	;to be done by usaid/furqan
    ; call SetTextColor

	mov edx, OFFSET menuMsg
	call WriteString
	call ReadInt

	cmp eax, 1
	;je sign_in
	cmp eax, 2
	;je create_new_account
	cmp eax, 3
	je exit_program
	jmp admin_menu

exit_program:
	call CRLF
	mov edx, OFFSET exitMsg
	call WriteString
	exit
main ENDP
END main
