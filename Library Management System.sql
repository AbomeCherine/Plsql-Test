-- Library Management System

--------------------------------
-- SQL Commands Executed:
--------------------------------

-- Creation of tables using DDL.
-- Create Authors Table
CREATE TABLE Authors (
    AuthorID NUMBER PRIMARY KEY,
    AuthorName VARCHAR2(100)
);

-- Create Books Table (One-to-Many with Authors)
CREATE TABLE Books (
    BookID NUMBER PRIMARY KEY,
    Title VARCHAR2(150),
    AuthorID NUMBER,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Create Members Table
CREATE TABLE Members (
    MemberID NUMBER PRIMARY KEY,
    MemberName VARCHAR2(100)
);

-- Create Borrowing Records (Many-to-One with Members, Books)
CREATE TABLE BorrowingRecords (
    RecordID NUMBER PRIMARY KEY,
    BookID NUMBER,
    MemberID NUMBER,
    BorrowDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

--------------------------------------------------------
-- Insertion, updating, and deletion of data using DML.
--------------------------------------------------------

NOTE: Information had to be inserted individually
-- Insert data into Authors table
INSERT INTO Authors (AuthorID, AuthorName)
VALUES (1, 'J.K. Rowling'), (2, 'George Orwell');

-- Insert data into Books table
INSERT INTO Books (BookID, Title, AuthorID)
VALUES (101, 'Harry Potter', 1), (102, '1984', 2);

-- Insert data into Members table
INSERT INTO Members (MemberID, MemberName)
VALUES (201, 'Alice'), (202, 'Bob');

INSERT INTO Members (MemberID, MemberName)
VALUES (203, 'Charlie');

-- Insert data into Borrowing Records table
INSERT INTO BorrowingRecords (RecordID, BookID, MemberID, BorrowDate, ReturnDate)
VALUES (301, 101, 201, TO_DATE('2023-09-01', 'YYYY-MM-DD'), '2023-09-10'), 
       (302, 102, 202, TO_DATE('2023-09-03', 'YYYY-MM-DD'), NULL);

-- Update the return date for a borrowed book
UPDATE BorrowingRecords
SET ReturnDate = TO_DATE('2023-09-12', 'YYYY-MM-DD')
WHERE RecordID = 302;

-- Delete a borrowing record
DELETE FROM Borrowing Records WHERE BookID = 102;


----------------------------------------------------------------
-- Joining tables and using subqueries to retrieve related data.
----------------------------------------------------------------

-- Retrieve borrowing records with member and book details (Join)
SELECT br.RecordID, b.Title, m.MemberName, br.BorrowDate, br.ReturnDate
FROM BorrowingRecords br
JOIN Books b ON br.BookID = b.BookID
JOIN Members m ON br.MemberID = m.MemberID;

-- Retrieve books borrowed by 'Alice' (Subquery)
SELECT Title FROM Books
WHERE BookID IN (SELECT BookID FROM BorrowingRecords WHERE MemberID = 
  (SELECT MemberID FROM Members WHERE MemberName = 'Alice'));

-----------------------------------------------
-- Transaction management using TCL operations.
-----------------------------------------------

select * from members;

delete from members where MemberID = 203;
-- Start a transaction by inserting some records into the Members table
INSERT INTO Members (MemberID, MemberName)
VALUES (203, 'Charlie');

-- Save the current state of the transaction
SAVEPOINT before_delete;

-- Insert another record
INSERT INTO Members (MemberID, MemberName)
VALUES (204, 'David');

-- Update a record
UPDATE Members
SET MemberName = 'Charlie Brown'
WHERE MemberID = 203;

-- Create a savepoint before deleting
SAVEPOINT before_update;

-- Delete a record
DELETE FROM Members
WHERE MemberID = 204;

-- At this point, we can either commit the transaction or rollback to a previous savepoint.
-- Rollback to the state before the delete operation (optional)
ROLLBACK ;

-- Commit the transaction to save the rest of the changes
COMMIT;

select * from members;


