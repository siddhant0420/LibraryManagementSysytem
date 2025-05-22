CREATE DATABASE LibraryManagement ;
USE LibraryManagement ;

-- Creating Authors table ;;;
CREATE TABLE Authors(
AuthorsID INT primary key Auto_increment ,
Name VARCHAR (50) NOT NULL,
Country VARCHAR (50),
Birthyear INT);

# Creating category table :

CREATE TABLE Category(
CategoryID INT PRIMARY KEY auto_increment ,
Category_Name VARCHAR (50) NOT NULL) ;

# BOOKS TABLE 
CREATE TABLE Books (
BookID INT PRIMARY KEY auto_increment , 
Title VARCHAR (100) NOT NULL,
AuthorID INT,
CategoryID INT ,
Publishedyear INT,
Quantity INT default 1 ,
foreign key (AuthorID) references AUthors (AuthorsID), 
foreign key (CategoryID) references Category (CategoryID)) ; 

# Members Table 
CREATE TABLE Members(
MemberID INT PRIMARY KEY auto_increment,
Name VARCHAR (50) not null , 
Address VARCHAR (100) , 
PhoneNumber VARCHAR (15) ,
Email VARCHAR (100)) ;
# Loan Table 
CREATE TABLE Loans(
LoadID INT PRIMARY KEY auto_increment,
BookID INT ,
MemberID INT ,
LoanDate DATE ,
ReturnDate DATE ,
Status VARCHAR (20) DEFAULT "ISSUED" ,
foreign key (BookID) references Books(BookID),
foreign key (MemberID) references Members (MemberID)
);
# INSERT sample data 

#Authors
INSERT INTO Authors (Name, Country, BirthYear) VALUES 
('J.K. Rowling', 'UK', 1965), 
('George R.R. Martin', 'USA', 1948), 
('Agatha Christie', 'UK', 1890);

-- Categories 
INSERT INTO Category (Category_Name) VALUES
('Fiction'), 
('Science Fiction'), 
('Mystery'), 
('Biography');

-- Books 
INSERT INTO Books (Title, AuthorID, CategoryID, PublishedYear, Quantity) VALUES 
('Harry Potter and the Sorcerer''s Stone', 1, 1, 1997, 5), 
('A Game of Thrones', 2, 1, 1996, 3), 
('Murder on the Orient Express', 3, 3, 1934, 4);

-- Members 
INSERT INTO Members (Name, Address, PhoneNumber, Email) VALUES 
('John Doe', '123 Elm Street', '123-456-7890', 'johndoe@example.com'), 
('Jane Smith', '456 Maple Avenue', '987-654-3210', 'janesmith@example.com');

-- Loans 
INSERT INTO Loans (BookID, MemberID, ReturnDate) VALUES 
(1, 1, '2025-05-20'), 
(2, 2, '2025-05-25');

select * from authors ;
select * from books ;
select * from category ;

-- 4. CRUD Operations

-- a) View all books 
SELECT * FROM Books;

-- b) Add a new book 
INSERT INTO Books (Title, AuthorID, CategoryID, PublishedYear, Quantity) VALUES 
('New Book Title', 1, 1, 2025, 2);

-- c) Update book quantity 
UPDATE Books SET Quantity = 10 WHERE BookID = 1;

# d) Delete a book 
DELETE FROM Books WHERE BookID = 5;

# 5. Join query to view issued books with member details 
SELECT Books.Title, Members.Name, Loans.LoanDate, Loans.ReturnDate FROM Loans 
JOIN Books ON Loans.BookID = Books.BookID 
JOIN Members ON Loans.MemberID = Members.MemberID 
WHERE Loans.Status = 'Issued';

-- 6. Stored Procedures

-- Procedure to Issue a Book 
DELIMITER $$ 
CREATE PROCEDURE IssueBook(IN member_id INT, IN book_id INT) 
BEGIN DECLARE stock INT; 
SELECT Quantity INTO stock FROM Books 
WHERE BookID = book_id; IF stock > 0 
THEN INSERT INTO Loans (BookID, MemberID, ReturnDate) VALUES 
(book_id, member_id, DATE_ADD(CURDATE(), INTERVAL 14 DAY)); 
UPDATE Books SET Quantity = Quantity - 1 WHERE BookID = book_id; 
ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book not available'; 
END IF; 
END $$ DELIMITER ;

-- Procedure to Return a Book 
DELIMITER $$ 
CREATE PROCEDURE ReturnBook(IN loan_id INT) BEGIN DECLARE book_id INT; 
SELECT BookID INTO book_id FROM Loans WHERE LoanID = loan_id; 
UPDATE Books SET Quantity = Quantity + 1 WHERE BookID = book_id; 
DELETE FROM Loans WHERE LoanID = loan_id; END $$ DELIMITER ;

-- 7. Triggers

-- Trigger to prevent deleting an author if books are still associated 
DELIMITER $$ 
CREATE TRIGGER BeforeAuthorDelete BEFORE DELETE ON Authors 
FOR EACH ROW BEGIN DECLARE book_count INT; 
SELECT COUNT(*) INTO book_count 
FROM Books WHERE AuthorsID = OLD.AuthorsID; 
IF book_count > 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete author with existing books'; 
END IF; END $$ DELIMITER ;

-- 8. Views

-- View to display all issued books and members 
CREATE VIEW IssuedBooks AS SELECT Books.Title, 
Members.Name, Loans.LoanDate, Loans.ReturnDate 
FROM Loans JOIN Books ON Loans.BookID = Books.BookID JOIN Members ON Loans.MemberID = Members.MemberID;

# 9. Advanced Queries

-- List of overdue books 
SELECT * FROM IssuedBooks WHERE ReturnDate < CURDATE();

-- Most borrowed books 
SELECT Title, COUNT(*) AS BorrowCount 
FROM Loans 
JOIN Books ON Loans.BookID = Books.BookID 
GROUP BY Title 
ORDER BY BorrowCount DESC LIMIT 5;