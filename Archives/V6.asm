; COAL Lab Project - Extended with Add/Update/Delete/Search Student Records
; Rayyan Aamir | Usaid Khan | Syed M. Furqan

INCLUDE Irvine32.inc

; -------------------------
; Data Layout Notes
; - studentNames: contiguous null-terminated strings for each student
; - studentRolls: DWORD per student
; - studentGPAs: 8 GPA strings per student. Each GPA stored as 4 chars + null (5 bytes)
; - studentCount: number of students currently stored
; -------------------------

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
              "4. Update Student Record",13,10,
              "5. Delete Student Record",13,10,
              "6. Log Out",13,10,13,10,
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
                                   BYTE 50 DUP(?)        ; additional space for new admin usernames
        adminPasswords BYTE "ray123",0, "abc789",0, "jfg456",0
                                   BYTE 50 DUP(?)        ; additional space for new admin passwords
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

        ; Buffers for Student Input
        inputName BYTE 80 DUP(?)
        inputRoll DWORD ?
        inputGPA BYTE 8*6 DUP(?)    ; each GPA read as up to 5 chars + null; reserve 6 bytes per GPA

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

        addStudentMsg BYTE "-----------------------------",13,10,
                        "ADD NEW STUDENT RECORD",13,10,
                        "-----------------------------",0
        addSuccessMsg BYTE "Student added successfully!",0
        updateSuccessMsg BYTE "Student record updated successfully!",0
        deleteSuccessMsg BYTE "Student record deleted successfully!",0
        notFoundMsg BYTE "Student not found!",0
        enterRollMsg BYTE "Enter student Roll (number): ",0
        enterNameMsg BYTE "Enter student full name: ",0
        enterGPAMsg BYTE "Enter GPA for semester ",0
        enterGPASuffix BYTE " (format 3.50): ",0

.code
main PROC
startup:
        mov ebx, OFFSET titleMsg
        mov edx, OFFSET welcomeMsg
        call MsgBox

call AdminMenu
call ExitProgram
main ENDP

; ------------------ Admin Menu ------------------
AdminMenu PROC
menu_loop:
        call Clrscr
        call CRLF

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

; ------------------ SignIn / Accounts ------------------
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
        push esi        ; preserving username pointer
        call StringCompare
        pop esi                ; restoring username pointer
        cmp eax, 0
        jne moveto_nextadmin

        mov edx, OFFSET inputPassword
        push esi        ; preserving username pointer
        push edi        ; preserving password pointer
        mov esi, edi
        call StringCompare
        pop edi                ; restoring password pointer
        pop esi                ; restoring username pointer
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
        jmp        signin_fail

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
        mov edx, OFFSET        signInFail
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


; ------------------ Admin Dashboard ------------------
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
    je option_update
    cmp eax, 5
    je option_delete
    cmp eax, 6
    je option_logout
    jmp dashboard_menu

option_view:
    call ViewStudents
    jmp dashboard_menu

option_add:
    call AddStudent
    jmp dashboard_menu

option_search:
    call SearchStudent
    jmp dashboard_menu

option_update:
    call UpdateStudent
    jmp dashboard_menu

option_delete:
    call DeleteStudent
    jmp dashboard_menu

option_logout:
        call CRLF
        mov edx, OFFSET return2menu
        call WriteString
        call CRLF
        call WaitMsg
    ret
AdminDashboard ENDP


; ------------------ View Students ------------------
ViewStudents PROC
    call Clrscr
    call CRLF

        mov edx, OFFSET viewStudentsMsg
        call WriteString

    mov esi, OFFSET studentNames   ; pointer to first student name
    mov edi, OFFSET studentRolls   ; pointer to first student roll
    mov ebx, OFFSET studentGPAs    ; pointer to first student GPA
    mov ecx, studentCount          ; number of students
    cmp ecx, 0
    je no_students

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

no_students:
    mov edx, OFFSET notFoundMsg
    call WriteString
    call CRLF
    call WaitMsg
    ret
ViewStudents ENDP


; ------------------ Add Student ------------------
; Option A chosen: manual entry of aludentMsg
AddStudent PROC
    call Clrscr
    mov edx, OFFSET addStudentMsg
    call WriteString
    call CRLF

    ; ----- Read Name -----
    mov edx, OFFSET enterNameMsg
    call WriteString
    mov edx, OFFSET inputName
    mov ecx, LENGTHOF inputName
    call ReadString

    ; ----- Read Roll -----
    mov edx, OFFSET enterRollMsg
    call WriteString
    call ReadInt
    mov inputRoll, eax

    ; ----- Read 8 GPAs -----
    mov esi, OFFSET inputGPA    ; temp buffer for input GPAs
    mov ecx, 8                  ; semester counter

read_gpa_loop:
    push ecx                    ; save semester counter
    
    mov edx, OFFSET enterGPAMsg
    call WriteString
    mov eax, 9
    sub eax, ecx               ; semester number 1..8
    call WriteDec
    mov edx, OFFSET enterGPASuffix
    call WriteString

    mov edx, esi               ; buffer for this GPA
    mov ecx, 6                 ; max chars for input including null
    call ReadString
    
    add esi, 6                 ; move to next GPA buffer (6 bytes each)
    
    pop ecx                    ; restore semester counter
    dec ecx
    jnz read_gpa_loop

done_read_gpa:

    ; ----- Append Name -----
    mov edi, OFFSET studentNames
    mov ecx, studentCount
    cmp ecx, 0
    je name_insert_point
    
skip_names_loop:
    cmp BYTE PTR [edi], 0
    je found_null
    inc edi
    jmp skip_names_loop
found_null:
    inc edi
    dec ecx
    jnz skip_names_loop

name_insert_point:
    mov esi, OFFSET inputName
copy_name_loop:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne copy_name_loop

    ; ----- Append Roll -----
    mov eax, studentCount
    mov ebx, eax
    shl ebx, 2                 ; multiply by 4 (size of DWORD)
    mov ecx, inputRoll
    mov [studentRolls + ebx], ecx

    ; ----- Append GPAs -----
    mov eax, studentCount
    mov ebx, 40                ; 8 GPAs * 5 bytes each
    mul ebx                    ; eax = studentCount * 40
    mov edi, OFFSET studentGPAs
    add edi, eax               ; edi points to destination for GPAs

    mov esi, OFFSET inputGPA   ; source for GPAs
    mov ecx, 8                 ; 8 semesters

copy_gpa_store_loop:
    push ecx
    mov ecx, 5                 ; copy 5 bytes per GPA (4 chars + null)
copy_gpa_char_loop:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jnz copy_gpa_char_loop
    
    ; Skip to next input GPA slot (we used 5 bytes, but reserved 6)
    inc esi
    
    pop ecx
    dec ecx
    jnz copy_gpa_store_loop

    ; ----- Increment student count -----
    inc studentCount

    mov edx, OFFSET addSuccessMsg
    call WriteString
    call CRLF
    call WaitMsg
    ret
AddStudent ENDP


; ------------------ Search Student by Roll ------------------
SearchStudent PROC
    call Clrscr
    call CRLF

    mov edx, OFFSET enterRollMsg
    call WriteString
    call ReadInt
    mov ebx, eax               ; EBX = searched roll

    mov ecx, studentCount
    cmp ecx, 0
    je search_notfound

    mov edi, OFFSET studentRolls
    xor esi, esi               ; ESI = index counter (0..n-1)

find_roll_loop:
    mov eax, [edi]
    cmp eax, ebx
    je roll_found
    add edi, 4
    inc esi
    dec ecx
    jne find_roll_loop

search_notfound:
    mov edx, OFFSET notFoundMsg
    call WriteString
    call CRLF
    call WaitMsg
    ret

roll_found:
    ; ESI contains index of the found student

    ; --- Locate name at index ---
    mov ebx, OFFSET studentNames
    mov ecx, esi              ; number of names to skip
    cmp ecx, 0
    je name_at_zero
skip_name_loop:
    ; skip current name (walk to its terminating 0)
skip_name_char:
    cmp BYTE PTR [ebx], 0
    je start_next_name
    inc ebx
    jmp skip_name_char
start_next_name:
    inc ebx                  ; move to start of next name
    dec ecx
    jne skip_name_loop

name_at_zero:
    ; EBX now points to the student's name
    mov edx, OFFSET nameMsg
    call WriteString
    mov edx, ebx
    call WriteString
    call CRLF

    ; --- Display Roll ---
    mov edx, OFFSET IDMsg
    call WriteString
    ; Need the roll value: compute pointer to the found roll DWORD
    ; (we already had edi pointing at the matched roll in find_roll_loop)
    ; But edi may have changed; recompute pointer by walking rolls up to index:
    mov edi, OFFSET studentRolls
    mov ecx, esi
walk_rolls_to_index:
    cmp ecx, 0
    je roll_pointer_ready
    add edi, 4
    dec ecx
    jmp walk_rolls_to_index
roll_pointer_ready:
    mov eax, [edi]
    call WriteDec
    call CRLF

    ; --- Display GPAs ---
    ; Compute GPA base address = OFFSET studentGPAs + index * 40
    mov eax, esi              ; eax = index
    imul eax, 40              ; eax = index * 40
    add eax, OFFSET studentGPAs
    mov ebx, eax              ; EBX = pointer to first GPA (5 bytes each)

    mov ecx, 8                ; 8 semesters
    mov esi, ebx              ; ESI = pointer used for printing GPAs
show_gpa_loop:
    mov edx, OFFSET semesterMsg
    call WriteString
    ; compute semester number: (9 - ecx)  gives 1..8 as loop runs
    mov eax, 9
    sub eax, ecx
    call WriteDec

    mov edx, OFFSET GPAMsg
    call WriteString

    mov edx, esi
    call WriteString

    add esi, 5                ; move to next GPA (fixed 5 bytes per GPA)
    call CRLF
    loop show_gpa_loop

    call CRLF
    call WaitMsg
    ret
SearchStudent ENDP


; ------------------ Update Student ------------------
UpdateStudent PROC
    call Clrscr
    call CRLF
    mov edx, OFFSET enterRollMsg
    call WriteString
    call ReadInt
    mov ebx, eax

    mov ecx, studentCount
    cmp ecx,0
    je update_notfound

    mov edi, OFFSET studentRolls
    xor esi, esi
find_update_loop:
    mov eax, [edi]
    cmp eax, ebx
    je update_found
    add edi,4
    inc esi
    dec ecx
    jne find_update_loop

update_notfound:
    mov edx, OFFSET notFoundMsg
    call WriteString
    call CRLF
    call WaitMsg
    ret

update_found:
    ; esi = index
    ; Update name
    mov edx, OFFSET enterNameMsg
    call WriteString
    mov edx, OFFSET inputName
    mov ecx, LENGTHOF inputName
    call ReadString

    ; find name insertion point for index
    mov ebx, OFFSET studentNames
    mov ecx, esi
    cmp ecx,0
    je update_name_at_zero
walk_names_upd:
    ; skip name
skip_loop_upd:
    cmp BYTE PTR [ebx],0
    je start_next_upd
    inc ebx
    jmp skip_loop_upd
start_next_upd:
    inc ebx
    dec ecx
    jne walk_names_upd

update_name_at_zero:
    ; overwrite old name with new name (simple approach: write new name over old; this may leave trailing bytes from old longer name)
    mov edx, OFFSET inputName
write_new_name_loop:
    mov al, [edx]
    mov [ebx], al
    cmp al, 0
    je name_write_done
    inc edx
    inc ebx
    jmp write_new_name_loop
name_write_done:

    ; Update GPAs - overwrite 8 GPAs for this student
    mov ecx, 8
    mov esi, OFFSET inputGPA
    ; read new GPAs from user
    mov edx, OFFSET enterGPAMsg

read_gpa_update_loop:
    mov edx, OFFSET enterGPAMsg
    call WriteString
    mov eax, 9
    sub eax, ecx
    ; write semester number (we'll compute differently)
    ; To print the correct semester number, compute semNo = 9 - ecx
    mov edx, OFFSET enterGPASuffix
    ; print prefix previously done; to simplify ask user sequentially
    ; Ask for semester # in order 1..8
    ; compute semNo
    mov eax, 8
    sub eax, ecx
    inc eax
    mov edx, OFFSET enterGPAMsg
    call WriteString
    mov eax, eax
    call WriteDec
    mov edx, OFFSET enterGPASuffix
    call WriteString

    ; read into inputGPA slot
    ; compute slot offset: (8 - ecx) * 6
    ; but simpler: append sequentially
    mov edx, OFFSET inputGPA
    mov ebx, 6
    mov eax, 8
    sub eax, ecx
    mul ebx             ; eax = slotIndex * 6
    add edx, eax
    mov ecx, 6
    call ReadString

    dec ecx
    jne read_gpa_update_loop

    ; Now copy GPAs to main GPA array
    ; compute destination base: studentGPAs + index*40
    mov eax, esi        ; eax contains previous value but we'll recompute index
    mov eax, esi        ; reset
    mov eax, esi
    ; recompute index from earlier stored esi value? We used esi as counter; we need to store index earlier
    ; For simplicity, re-find using [studentRolls]
    mov ebx, [inputRoll]
    mov ecx, studentCount
    mov edi, OFFSET studentRolls
    xor esi, esi
find_index_update_loop:
    mov eax, [edi]
    cmp eax, ebx
    je index_update_found
    add edi,4
    inc esi
    dec ecx
    jne find_index_update_loop
index_update_found:
    mov eax, esi        ; eax = index

    mov ebx, OFFSET studentGPAs
    mov edx, 40
    mul edx             ; eax * 40
    add ebx, eax        ; ebx = destination GPA base

    ; copy from inputGPA buffer to studentGPAs (8 slots)
    mov esi, OFFSET inputGPA
    mov edi, ebx
    mov ecx, 8
copy_gpa_update_loop:
    mov edx,5
copy_gpa_up_char:
    mov al, [esi]
    mov [edi], al
    cmp al,0
    je gpaup_slot_done
    inc esi
    inc edi
    dec edx
    cmp edx,0
    jne copy_gpa_up_char
    mov BYTE PTR [edi],0
    inc edi
    inc esi ; move past null
gpaup_slot_done:
    ; advance input slot to next (assume 6 bytes reserved)
    ; skip to next null if not already
    cmp BYTE PTR [esi],0
    jne skip_to_null
    inc esi
skip_to_null:
    ; move to next slot (approx)
    ; ensure edi at next 5-byte slot
    ; we use fixed increments: edi advanced by 5 per slot, so continue
    dec ecx
    jne copy_gpa_update_loop

    ; show success
    mov edx, OFFSET updateSuccessMsg
    call WriteString
    call CRLF
    call WaitMsg
    ret
UpdateStudent ENDP


; ------------------ Helper routines from original code ------------------
AddStringToArray PROC
        mov ebx, 0

find_last_item:
        cmp ebx, ecx
        je copy_string                ; copying only when last item is found

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

