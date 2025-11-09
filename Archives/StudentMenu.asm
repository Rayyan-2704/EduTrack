COMMENT !
COAL Lab Project
Rayyan Aamir | Usaid Khan | Syed Muhammad Furqan
Module: Student Record Management (StudentMenu.asm)
Description:
This module manages student records using memory arrays.
It includes features to view, add, update, delete, and search student data.
Integrated with V2.asm after successful admin sign-in.
!
INCLUDE Irvine32.inc

.data
studentMenuMsg BYTE "-----------------------------",13,10,
                 "STUDENT RECORD SYSTEM",13,10,
                 "-----------------------------",13,10,13,10,
                 "1. View All Student Records",13,10,
                 "2. Add New Student Record",13,10,
                 "3. Update Student Record",13,10,
                 "4. Delete Student Record",13,10,
                 "5. Search Student Record",13,10,
                 "6. Logout",13,10,13,10,
                 "Enter your choice: ",0

maxStudents = 50

studentCount DWORD 0

studentIDs DWORD maxStudents DUP(?)
studentGrades DWORD maxStudents*3 DUP(?)
studentNames BYTE maxStudents*30 DUP(?)

inputName BYTE 30 DUP(?)
inputID DWORD ?
inputGrade1 DWORD ?
inputGrade2 DWORD ?
inputGrade3 DWORD ?

viewMsg BYTE "All Student Records:",13,10,0
noRecordsMsg BYTE "No student records found!",13,10,0
enterIDMsg BYTE "Enter Student ID: ",0
enterNameMsg BYTE "Enter Student Name: ",0
enterG1Msg BYTE "Enter Grade 1: ",0
enterG2Msg BYTE "Enter Grade 2: ",0
enterG3Msg BYTE "Enter Grade 3: ",0
addSuccessMsg BYTE "Student record added successfully!",13,10,0
updateSuccessMsg BYTE "Record updated successfully!",13,10,0
deleteSuccessMsg BYTE "Record deleted successfully!",13,10,0
notFoundMsg BYTE "No record found for the given ID!",13,10,0

recordLine BYTE "-----------------------------",13,10,0

.code

StudentMenu PROC
menu_loop:
    call Clrscr
    mov edx, OFFSET studentMenuMsg
    call WriteString
    call ReadInt

    cmp eax, 1
    je ViewAllRecords
    cmp eax, 2
    je AddStudent
    cmp eax, 3
    je UpdateStudent
    cmp eax, 4
    je DeleteStudent
    cmp eax, 5
    je SearchStudent
    cmp eax, 6
    je logout_menu
    jmp menu_loop

logout_menu:
    ret
StudentMenu ENDP


AddStudent PROC
    cmp studentCount, maxStudents
    jae tooMany
    call Clrscr

    mov edx, OFFSET enterIDMsg
    call WriteString
    call ReadInt
    mov inputID, eax

    mov edx, OFFSET enterNameMsg
    call WriteString
    mov edx, OFFSET inputName
    mov ecx, LENGTHOF inputName
    call ReadString

    mov edx, OFFSET enterG1Msg
    call WriteString
    call ReadInt
    mov inputGrade1, eax

    mov edx, OFFSET enterG2Msg
    call WriteString
    call ReadInt
    mov inputGrade2, eax

    mov edx, OFFSET enterG3Msg
    call WriteString
    call ReadInt
    mov inputGrade3, eax

    mov ecx, studentCount
    mov ebx, ecx
    imul ebx, 4
    mov eax, inputID
    mov [studentIDs+ebx], eax

    mov esi, OFFSET studentNames
    mov edi, OFFSET inputName
    mov ecx, studentCount
find_name_slot:
    cmp ecx, 0
    je copy_now
    find_next_name:
        cmp BYTE PTR [esi], 0
        je after_name
        inc esi
        jmp find_next_name
    after_name:
        inc esi
        loop find_name_slot
copy_now:
    mov al, [edi]
    mov [esi], al
    cmp al, 0
    je name_done
    inc esi
    inc edi
    jmp copy_now
name_done:

    mov ecx, studentCount
    mov ebx, ecx
    imul ebx, 12
    mov eax, inputGrade1
    mov [studentGrades+ebx], eax
    mov eax, inputGrade2
    mov [studentGrades+ebx+4], eax
    mov eax, inputGrade3
    mov [studentGrades+ebx+8], eax

    inc studentCount

    mov edx, OFFSET addSuccessMsg
    call CRLF
    call WriteString
    call WaitMsg
    jmp StudentMenu

tooMany:
    ret
AddStudent ENDP


ViewAllRecords PROC
    call Clrscr
    cmp studentCount, 0
    je no_records
    mov edx, OFFSET viewMsg
    call WriteString
    mov ecx, studentCount
    mov esi, OFFSET studentNames
    mov edi, OFFSET studentGrades
    mov ebx, OFFSET studentIDs

view_loop:
    mov eax, [ebx]
    call CRLF
    mov edx, OFFSET recordLine
    call WriteString

    mov edx, OFFSET "ID: ",0
    call WriteString
    mov eax, [ebx]
    call WriteDec
    call CRLF

    mov edx, OFFSET "Name: ",0
    call WriteString
    mov edx, esi
    call WriteString
    call CRLF

    mov edx, OFFSET "Grades: ",0
    call WriteString
    mov eax, [edi]
    call WriteDec
    mov edx, OFFSET ", ",0
    call WriteString
    mov eax, [edi+4]
    call WriteDec
    mov edx, OFFSET ", ",0
    call WriteString
    mov eax, [edi+8]
    call WriteDec
    call CRLF

    mov eax, [edi]
    add eax, [edi+4]
    add eax, [edi+8]
    mov ebx, 3
    cdq
    div ebx
    mov edx, OFFSET "Average: ",0
    call WriteString
    call WriteDec
    call CRLF

    call CRLF

next_record:
    add edi, 12
    add ebx, 4

    find_next:
        cmp BYTE PTR [esi], 0
        je after_name2
        inc esi
        jmp find_next
    after_name2:
        inc esi

    loop view_loop
    call WaitMsg
    jmp StudentMenu

no_records:
    mov edx, OFFSET noRecordsMsg
    call WriteString
    call WaitMsg
    jmp StudentMenu
ViewAllRecords ENDP


SearchStudent PROC
    call Clrscr
    mov edx, OFFSET enterIDMsg
    call WriteString
    call ReadInt
    mov ebx, eax

    mov ecx, studentCount
    mov edi, OFFSET studentIDs
    mov esi, OFFSET studentNames
    mov edx, OFFSET studentGrades

search_loop:
    cmp ecx, 0
    je not_found
    mov eax, [edi]
    cmp eax, ebx
    je found_record
    add edi, 4
    add edx, 12
    find_next_n:
        cmp BYTE PTR [esi], 0
        je after_n
        inc esi
        jmp find_next_n
    after_n:
        inc esi
    loop search_loop

not_found:
    mov edx, OFFSET notFoundMsg
    call WriteString
    call WaitMsg
    jmp StudentMenu

found_record:
    mov edx, OFFSET "Record Found:",13,10,0
    call WriteString
    mov edx, esi
    call WriteString
    call CRLF
    call WaitMsg
    jmp StudentMenu
SearchStudent ENDP


UpdateStudent PROC
    call Clrscr
    mov edx, OFFSET enterIDMsg
    call WriteString
    call ReadInt
    mov ebx, eax

    mov ecx, studentCount
    mov edi, OFFSET studentIDs
    mov esi, OFFSET studentNames
    mov edx, OFFSET studentGrades

update_loop:
    cmp ecx, 0
    je not_found_update
    mov eax, [edi]
    cmp eax, ebx
    je found_update
    add edi, 4
    add edx, 12
    find_next_u:
        cmp BYTE PTR [esi], 0
        je after_u
        inc esi
        jmp find_next_u
    after_u:
        inc esi
    loop update_loop

not_found_update:
    mov edx, OFFSET notFoundMsg
    call WriteString
    call WaitMsg
    jmp StudentMenu

found_update:
    mov edx, OFFSET enterG1Msg
    call WriteString
    call ReadInt
    mov [edx], eax
    mov edx, OFFSET enterG2Msg
    call WriteString
    call ReadInt
    mov [edx+4], eax
    mov edx, OFFSET enterG3Msg
    call WriteString
    call ReadInt
    mov [edx+8], eax
    mov edx, OFFSET updateSuccessMsg
    call WriteString
    call WaitMsg
    jmp StudentMenu
UpdateStudent ENDP


DeleteStudent PROC
    call Clrscr
    mov edx, OFFSET enterIDMsg
    call WriteString
    call ReadInt
    mov ebx, eax

    mov ecx, studentCount
    mov edi, OFFSET studentIDs
    mov esi, OFFSET studentNames
    mov edx, OFFSET studentGrades

del_loop:
    cmp ecx, 0
    je not_found_del
    mov eax, [edi]
    cmp eax, ebx
    je found_del
    add edi, 4
    add edx, 12
    find_next_d:
        cmp BYTE PTR [esi], 0
        je after_d
        inc esi
        jmp find_next_d
    after_d:
        inc esi
    loop del_loop

not_found_del:
    mov edx, OFFSET notFoundMsg
    call WriteString
    call WaitMsg
    jmp StudentMenu

found_del:
    mov [edi], 0
    mov [edx], 0
    mov [edx+4], 0
    mov [edx+8], 0
    mov BYTE PTR [esi], 0
    dec studentCount
    mov edx, OFFSET deleteSuccessMsg
    call WriteString
    call WaitMsg
    jmp StudentMenu
DeleteStudent ENDP

END
