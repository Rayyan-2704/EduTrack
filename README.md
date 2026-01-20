# 📘 EduTrack – Student Record System (x86 Assembly)

EduTrack is a **console-based Student Record Management System** developed in **x86 Assembly Language** using the **Irvine32 library**.  
This project was built as part of the **COAL Lab Project** and demonstrates low-level programming concepts such as memory manipulation, string handling, and procedural design.

---

## 🛠️ Technologies Used

- **Language:** x86 Assembly (MASM)
- **Library:** Irvine32.inc
- **IDE:** Visual Studio (MASM enabled)

---

## 👨‍💻 Developers

- [Rayyan Aamir](https://github.com/Rayyan-2704)
- [Usaid Khan](https://github.com/MuhammadUsaidKhan) 
- [Syed Muhammad Furqan](https://github.com/HSMFurqan) 

---

## ✨ Features

### 🔐 Admin Module
- Admin sign-in system
- Create new admin accounts
- Username duplication check
- Password length validation (minimum 6 characters)

### 📋 Student Record Management
- View all student records
- Add new student records
- Search students by roll number
- Update student records
- Delete student records

### 🎓 Student Data
- Student full name
- Unique roll number
- GPA for **8 semesters**
- GPA validation (range **0.00 – 4.00**)

---

## 🗂️ Data Storage Design

All records are stored **in memory** using static arrays:

- **Student Names:** Null-terminated strings stored contiguously
- **Roll Numbers:** DWORD array
- **GPAs:** 8 GPAs per student, stored as `"X.XX\0"`
- **Admin Credentials:** Stored as null-terminated strings

⚠️ **Note:** No file handling is used. All data is lost when the program exits.

---

## 🧠 Concepts Demonstrated

- Low-level string comparison and copying
- Manual memory traversal
- Stack and register management
- Modular programming using procedures
- Input validation in assembly
- Conditional branching and loops

---

## ▶️ How to Run

1. Install **Visual Studio** with:
   - Desktop development with C++
   - MASM (Microsoft Macro Assembler)

2. Add `Irvine32.inc`, `Irvine32.lib`, and `Irvine32.asm` to your project directory.

3. Create a **Win32 Console Application**.

4. Add the provided `.asm` file to the project.

5. Set build configuration to **x86 (64-bit)**.

6. Build and run the program.
