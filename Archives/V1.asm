COMMENT !
	Project Progress:
		Admin Menu - Done
		Sign In - Done
		Create New Account - In Progress
!

; COAL Lab Project
; Rayyan Aamir | Usaid Khan | Syed Muhammad Furqan
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

	; Exit Message
	exitMsg BYTE "Thank you for using Student Record System!",0

	; Admin Details (Hardcoded)
	adminUsernames BYTE "rayyan0687",0, "usaid0832",0, "furqan0766",0
	adminPasswords BYTE "ray123",0, "abc789",0, "jfg456",0
	adminCount DWORD 3

	; Buffers for Sign-In/Create New Account input
	inputUsername BYTE 20 DUP(?)
	inputPassword BYTE 20 DUP(?)

	; Sign-In/Create New Account Messages
	signinMsg BYTE "-----------------------------",13,10,
			"ADMIN SIGN-IN",13,10,
			"-----------------------------",0
	signInSuccess BYTE "Sign In Successful!",0
	signInFail BYTE "Invalid username or password entered!",0

	newAccMsg BYTE "-----------------------------",13,10,
			"CREATE NEW ADMIN ACCOUNT",13,10,
			"-----------------------------",0
	newAccSuccess BYTE "Account created successfully!",0
	newAccFail BYTE "Account with the username already exists",0
	enterUsername BYTE "Enter username: ",0
	enterPassword BYTE "Enter password: ",0


.code
main PROC
startup:
	mov ebx, OFFSET titleMsg
	mov edx, OFFSET welcomeMsg
	call MsgBox

call AdminMenu

call ExitProgram

main ENDP


AdminMenu PROC
menu_loop:
	call Clrscr
	call CRLF

	; mov eax, 14 + (1 * 16)	;to be done by usaid/furqan
    ; call SetTextColor

	mov edx, OFFSET menuMsg
	call WriteString
	call ReadInt

	cmp eax, 1
	je sign_in
	cmp eax, 2
	;je create_new_account
	cmp eax, 3
	je end_loop
	jmp menu_loop

end_loop:
	ret
AdminMenu ENDP


ExitProgram PROC
	call CRLF
	mov edx, OFFSET exitMsg
	call WriteString
	exit
ExitProgram ENDP


sign_in PROC
	call Clrscr
	mov edx, OFFSET enterUsername
	call WriteString
	mov edx, OFFSET inputUsername
	mov ecx, LENGTHOF inputUsername
	call ReadString

	mov edx, OFFSET enterPassword
	call WriteString
	mov edx, OFFSET inputPassword
	mov ecx, LENGTHOF inputPassword
	call ReadString

	mov esi, OFFSET adminUsernames
	mov edi, OFFSET adminPasswords
	mov ecx, adminCount

signin_check_loop:

	mov edx, OFFSET inputUsername
	push esi	; preserving username pointer
	call StringCompare
	pop esi		; restoring username pointer
	cmp eax, 0
	jne moveto_nextadmin

	mov edx, OFFSET inputPassword
	push esi	; preserving username pointer
	push edi	; preserving password pointer
	mov esi, edi
	call StringCompare
	pop edi		; restoring password pointer
	pop esi		; restoring username pointer
	cmp eax, 0
	je signin_success

moveto_nextadmin:
find_next_username:
    cmp byte ptr [esi], 0
	je found_username_null
    inc esi
    jmp find_next_username
found_username_null:
	inc esi

find_next_password:
	cmp byte ptr [edi], 0
	je found_password_null
	inc edi
	jmp find_next_password
found_password_null:
	inc edi

	loop signin_check_loop
	jmp	signin_fail

signin_success:
	call CRLF
	mov edx, OFFSET signInSuccess
	call WriteString
	call CRLF
	call WaitMsg
	jmp AdminMenu

signin_fail:
	call CRLF
	mov edx, OFFSET	signInFail
	call WriteString
	call CRLF
	call WaitMsg
	jmp AdminMenu
sign_in ENDP


StringCompare PROC
	mov eax, 1

compare_loop:
	mov al, [edx]
	mov bl, [esi]
	cmp al, bl
	jne not_equal
	cmp al, 0
	je equal
	inc edx
	inc esi
	jmp compare_loop

equal:
	mov eax, 0
	ret

not_equal:
	mov eax, 1
	ret
stringCompare ENDP

END main
