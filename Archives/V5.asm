COMMENT !
	Project Progress:
		Admin Menu - Done
		Sign In - Done
		Create New Account - Done   +  Additional Helper functions like StringCompare, AddStringToArray, CheckPasswordLength etc
		Admin Dashboard - Done
		View Student Record Details - Done
		Log Out - Done
!

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
			"-----------------------------",13,10,13,10,
			"1. Sign In",13,10,
			"2. Create New Account",13,10,
			"3. Exit Program",13,10,13,10,
			"Enter your choice: ",0

	; Admin Dashboard Message
	dashboardMsg BYTE "-----------------------------",13,10,
              "ADMIN DASHBOARD",13,10,
              "-----------------------------",13,10,13,10,
              "1. View All Student Records",13,10,
              "2. Add New Student Record",13,10,
              "3. Search Student by Roll Number",13,10,
              "4. Delete Student Record",13,10,
              "5. Log Out",13,10,13,10,
              "Enter your choice: ",0
	return2menu BYTE "Returning to Admin Module Menu...",0

	; View Student Record Messages
	viewStudentsMsg BYTE "-----------------------------",13,10,
              "VIEWING STUDENT RECORD DETAILS",13,10,
              "-----------------------------",13,10,13,10,0
	nameMsg BYTE "Student Name: ",0
	IDMsg BYTE "Student ID: ",0
	semesterMsg BYTE "Semester ",0
	GPAMsg BYTE " GPA: ",0
	separator BYTE " | ",0

	; Exit Message
	exitMsg BYTE "Thank you for using Student Record System!",0

	; Admin Details (Hardcoded)
	adminUsernames BYTE "rayyan0687",0, "usaid0832",0, "furqan0766",0
				   BYTE 50 DUP(?)	; additional space for new admin usernames
	adminPasswords BYTE "ray123",0, "abc789",0, "jfg456",0
				   BYTE 50 DUP(?)	; additional space for new admin passwords
	adminCount DWORD 3

	; Student Record Details (Hardcoded)
	studentNames BYTE "Ali Tariq",0, "Tazeen Ahmed",0, "Hassan Ali",0
				 BYTE 1000 DUP(?)  ; extra space for new students
	studentCount DWORD 3

	studentRolls DWORD 101, 102, 103
				 DWORD 20 DUP(?)   ; extra space for new students        

	; Hardcoded Student GPAs (8 semesters per student)
	studentGPAs BYTE "3.50",0,"3.60",0,"3.70",0,"3.80",0,"3.90",0,"4.00",0,"3.90",0,"3.80",0
				BYTE "3.20",0,"3.30",0,"3.40",0,"3.50",0,"3.60",0,"3.70",0,"3.50",0,"3.60",0
				BYTE "3.00",0,"3.10",0,"3.20",0,"3.30",0,"3.40",0,"3.50",0,"3.30",0,"3.20",0
				BYTE 100 DUP(?)   ; extra space for new students

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
	newAccDup BYTE "Account with the username already exists",0
	passwordShort BYTE "Invalid password (Password must be of 6 characters minimum)",0
	enterUsername BYTE "Enter username: ",0
	enterPassword BYTE "Enter password (minimum length = 6): ",0


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
	je option_signin
	cmp eax, 2
	je option_createnewacc
	cmp eax, 3
	je end_loop
	jmp menu_loop

	option_signin:
    call SignIn
    jmp menu_loop

option_createnewacc:
    call CreateNewAccount
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


SignIn PROC
	call Clrscr
	mov edx, OFFSET signinMsg
	call WriteString
	call CRLF
	call CRLF

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
    cmp BYTE PTR [esi], 0
	je found_username_null
    inc esi
    jmp find_next_username
found_username_null:
	inc esi

find_next_password:
	cmp BYTE PTR [edi], 0
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
	call AdminDashboard
	ret

signin_fail:
	call CRLF
	mov edx, OFFSET	signInFail
	call WriteString
	call CRLF
	call WaitMsg
	ret
SignIn ENDP


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


CreateNewAccount PROC
	call Clrscr
	mov edx, OFFSET newAccMsg
	call WriteString
	call CRLF
	call CRLF

enter_username:
	mov edx, OFFSET enterUsername
	call WriteString
	mov edx, OFFSET inputUsername
	mov ecx, LENGTHOF inputUsername
	call ReadString

	mov esi, OFFSET adminUsernames
	mov ecx, adminCount

check_username_dup:
	push esi
	mov edx, OFFSET inputUsername
	call StringCompare
	pop esi
	cmp eax, 0
	jne next_username

	mov edx, OFFSET newAccDup
	call WriteString
	call CRLF
	call CRLF
	jmp enter_username

next_username:
	cmp BYTE PTR [esi], 0
	je found_username_null
	inc esi
	jmp next_username

found_username_null:
	inc esi
	loop check_username_dup

enter_password:
	mov edx, OFFSET enterPassword
	call WriteString
	mov edx, OFFSET inputPassword

	mov ecx, LENGTHOF inputPassword
	call ReadString
	call CheckPasswordLength
	cmp eax, 0
	je add_username_password

	mov edx, OFFSET passwordShort
	call WriteString
	call CRLF
	call CRLF
	jmp enter_password

add_username_password:
	mov esi, OFFSET adminUsernames
	mov edx, OFFSET inputUsername
	mov ecx, adminCount
	call AddStringToArray

	mov esi, OFFSET adminPasswords
	mov edx, OFFSET inputPassword
	mov ecx, adminCount
	call AddStringToArray

	inc adminCount

	call CRLF
	mov edx, OFFSET newAccSuccess
	call WriteString
	call CRLF
	call WaitMsg
	ret
CreateNewAccount ENDP


AdminDashboard PROC
dashboard_menu:
    call Clrscr
    call CRLF

    mov edx, OFFSET dashboardMsg
	call WriteString
	call ReadInt

    cmp eax, 1
    je option_view
    cmp eax, 2
    je option_add
    cmp eax, 3
    je option_search
    cmp eax, 4
    je option_delete
    cmp eax, 5
    je option_logout
    jmp dashboard_menu

option_view:
    call ViewStudents
    jmp dashboard_menu

option_add:
    ;call RemoveStudent
    jmp dashboard_menu

option_search:
    ;call Search
    jmp dashboard_menu

option_delete:
    ;call UpdateStudent
    jmp dashboard_menu

option_logout:
	call CRLF
	mov edx, OFFSET return2menu
	call WriteString
	call CRLF
	call WaitMsg
    ret
AdminDashboard ENDP


ViewStudents PROC
    call Clrscr
    call CRLF

	mov edx, OFFSET viewStudentsMsg
	call WriteString

    mov esi, OFFSET studentNames   ; pointer to first student name
    mov edi, OFFSET studentRolls   ; pointer to first student roll
    mov ebx, OFFSET studentGPAs    ; pointer to first student GPA
    mov ecx, studentCount          ; number of students
    
view_loop:
    mov edx, OFFSET nameMsg
    call WriteString
	mov edx, esi
	call WriteString
	call CRLF

	mov edx, OFFSET IDMsg
	call WriteString
    mov eax, [edi]
    call WriteDec
    call CRLF

	push ecx
    mov ecx, 8
gpa_loop:
	mov edx, OFFSET semesterMsg
	call WriteString
	mov eax, 9
	sub eax, ecx
	call WriteDec
	mov edx, OFFSET GPAMsg
	call WriteString
    mov edx, ebx
	call WriteString
    add ebx, 5
	call CRLF
    loop gpa_loop
    call CRLF

	pop ecx
find_next_studentname:
    cmp BYTE PTR [esi], 0
	je found_next
    inc esi
    jmp find_next_studentname
found_next:
	inc esi

    add edi, 4
    loop view_loop

    call CRLF
    call WaitMsg
    ret
ViewStudents ENDP


AddStringToArray PROC
	mov ebx, 0

find_last_item:
	cmp ebx, ecx
	je copy_string		; copying only when last item is found

next_item:
	cmp BYTE PTR [esi], 0
	je move_to_next_item
	inc esi
	jmp next_item

move_to_next_item:
	inc esi
	inc ebx
	jmp find_last_item

copy_string:
	mov al, [edx]
	mov [esi], al
	cmp al, 0
	je copying_done
	inc esi
	inc edx
	jmp copy_string
	
copying_done:
	ret
AddStringToArray ENDP


CheckPasswordLength PROC
	mov ecx, 0
	mov esi, edx

character_count:
	cmp BYTE PTR [esi], 0
	je check_count
	inc ecx
	inc esi
	jmp character_count

check_count:
	cmp ecx, 6
	jb too_short
	mov eax, 0
	ret

too_short:
	mov eax, 1
	ret
CheckPasswordLength ENDP

END main
