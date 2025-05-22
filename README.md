# LibraryManagementSysytem SQL Project

This project is a fully functional *SQL-based Library Management System* designed to manage the day-to-day operations of a library, including managing books, authors, members, and book loans. It demonstrates the use of relational database concepts, stored procedures, triggers, views, and advanced SQL queries.

---

## 📁 Database Structure

### 1. Tables
- *Authors* – Stores author details
- *Categories* – Stores book genres
- *Books* – Stores book details
- *Members* – Stores library member data
- *Loans* – Stores issued book records

---

### 2. Sample Data
- Pre-filled data for authors, books, categories, and members
- Example book loans to demonstrate functionality

---

## ⚙️ SQL Features Implemented

### ✅ CRUD Operations
- Add, view, update, and delete books and member records

### ✅ Stored Procedures
- *IssueBook*: Issues a book to a member and updates stock
- *ReturnBook*: Returns a book and updates inventory

### ✅ Triggers
- Prevents deletion of an author if books are still associated

### ✅ Views
- *IssuedBooks*: Shows all currently issued books with member info

### ✅ Advanced Queries
- Most borrowed books
- Overdue books

---
