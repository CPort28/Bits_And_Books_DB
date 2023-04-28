-- Creating New Publisher
INSERT INTO PUBLISHER
VALUES (1000, 'Canaan Publishing Group', '6145001234', 'supply@canaanco.com');

-- Checking that the new publisher was created
SELECT *
FROM PUBLISHER
WHERE publisher_id = 1000;

-- Creating New Book
INSERT INTO BOOK
VALUES ('0101010101010', 2005, 24.99, 'Sample Title', 1000);

-- Checking that the new book was created
SELECT *
FROM BOOK
WHERE isbn = '0101010101010';

-- Creating New Name
INSERT INTO NAME
VALUES (300, 'Canaan', 'Porter', 'M.');

-- Checking that the new name was created
SELECT *
FROM NAME
WHERE name_id = 300;

-- Creating New Author with name Canaan M. Porter
INSERT INTO AUTHOR
VALUES (500, 300, '1912-12-24', '1998-5-8');

-- Checking that the new AUTHOR was created
SELECT author_id, birth_date, death_date, fname, middle_inits, lname
FROM AUTHOR, NAME
WHERE author_id = 500 AND AUTHOR.name_id = NAME.name_id;

-- Connecting Newly Created Author and Book
INSERT INTO WRITTEN_BY
VALUES (500, '0101010101010');

-- Checking that the connection was made
SELECT B.title, N.fname, N.lname, B.publisher_id
FROM BOOK B, WRITTEN_BY WB, AUTHOR A, NAME N
WHERE B.isbn = WB.isbn AND WB.author_id = A.author_id
AND A.name_id = N.name_id AND A.author_id = 500;

-- Connecting the new book to a category
INSERT INTO BOOK_CATEGORY
VALUES ('0101010101010', 2);

-- Checking that the connection was made
SELECT B.title, C.cat_name
FROM BOOK B, BOOK_CATEGORY BC, CATEGORY C
WHERE B.isbn = BC.isbn AND BC.category_id = C.category_id
AND B.isbn = '0101010101010';

-- Creating New Address
INSERT INTO ADDRESS
VALUES (1000, '1234 Lane Ave', NULL , 'Columbus', 'OH', '43210', 'USA');

-- Checking that the new address was created
SELECT *
FROM ADDRESS
WHERE address_id = 1000;

-- Creating New User with name Canaan M. Porter
INSERT INTO USER
VALUES (200, 300, 'canaan@mail.com', '1234567898', 1000);

-- Checking the new user
SELECT N.fname, N.middle_inits, N.lname, U.email, U.phone_no, A.address, A.city, A.state
FROM USER U, NAME N, ADDRESS A
WHERE U.name_id = N.name_id AND U.address_id = A.address_id
AND U.user_id = 200;

-- DELETES
-- Observe the WRITTEN_BYs of the books from Canaan Publishing Group
SELECT BOOK.isbn, author_id
FROM WRITTEN_BY, BOOK
WHERE WRITTEN_BY.isbn = BOOK.isbn
AND BOOK.publisher_id = 1000;

-- Deleting WRITTEN_BY entries on books from Canaan Publishing Group
DELETE FROM WRITTEN_BY
WHERE isbn IN (SELECT isbn
               FROM BOOK
               WHERE publisher_id = 1000);

-- Make the same query as before, should have no results
SELECT BOOK.isbn, author_id
FROM WRITTEN_BY, BOOK
WHERE WRITTEN_BY.isbn = BOOK.isbn
AND BOOK.publisher_id = 1000;

-- Checking the book categories on books from Canaan Publishing Group
SELECT BOOK.isbn, category_id
FROM BOOK_CATEGORY, BOOK
WHERE BOOK_CATEGORY.isbn = BOOK.isbn
AND BOOK.publisher_id = 1000;

-- Deleting BOOK_CATEGORY entries on books from Canaan Publishing Group
DELETE FROM BOOK_CATEGORY
WHERE isbn IN (SELECT isbn
               FROM BOOK
               WHERE publisher_id = 1000);

-- Checking the same query, should be empty
SELECT BOOK.isbn, category_id
FROM BOOK_CATEGORY, BOOK
WHERE BOOK_CATEGORY.isbn = BOOK.isbn
AND BOOK.publisher_id = 1000;

-- Checking books written by Canaan Publishing Group
SELECT *
FROM BOOK
WHERE BOOK.publisher_id = 1000;

-- Deleting BOOK entries from Canaan Publishing Group
DELETE FROM BOOK
WHERE isbn IN (SELECT isbn
               FROM BOOK
               WHERE publisher_id = 1000);

-- Comparing the last query, should be empty now
SELECT *
FROM BOOK
WHERE BOOK.publisher_id = 1000;

-- Deleting WRITTEN_BY entries written by Canaan Porter
DELETE FROM WRITTEN_BY
WHERE author_id = 500;

-- Querying for the Canaan Publishing Group
SELECT *
FROM PUBLISHER
WHERE publisher_id = 1000;

-- Deleting Canaan Publishing Group
DELETE FROM PUBLISHER
WHERE publisher_id = 1000;

-- Making the same query, should be empty
SELECT *
FROM PUBLISHER
WHERE publisher_id = 1000;

-- Checking the book orders of USER 21
SELECT B.title, BO.quantity
FROM BOOK B, BOOK_ORDER BO, "ORDER" O, USER U
WHERE U.user_id = O.customer_id AND O.order_id = BO.order_id
AND BO.isbn = B.isbn AND U.user_id = 21;

-- Deleting all the book orders of USER #21
DELETE FROM BOOK_ORDER
WHERE order_id IN (SELECT order_id
                   FROM "ORDER" O, USER U
                   WHERE O.customer_id = U.user_id
                   AND U.user_id = 21);

-- Making the same query, should be empty
SELECT B.title, BO.quantity
FROM BOOK B, BOOK_ORDER BO, "ORDER" O, USER U
WHERE U.user_id = O.customer_id AND O.order_id = BO.order_id
AND BO.isbn = B.isbn AND U.user_id = 21;

-- Checking the orders of USER 21
SELECT O.order_id, O.sale_date
FROM "ORDER" O, USER U
WHERE U.user_id = O.customer_id AND U.user_id = 21;

-- Deleting all the orders of USER #21
DELETE FROM "ORDER"
WHERE order_id IN (SELECT order_id
                   FROM "ORDER" O, USER U
                   WHERE O.customer_id = U.user_id
                   AND U.user_id = 21);

-- Same query, should be empty now
SELECT O.order_id, O.sale_date
FROM "ORDER" O, USER U
WHERE U.user_id = O.customer_id AND U.user_id = 21;

-- Checking if User #1 is an employee
SELECT *
FROM EMPLOYEE, USER
WHERE employee_id = USER.user_id
AND user_id = 1;

-- Deleting the EMPLOYEE tuple for USER #1
DELETE FROM EMPLOYEE
WHERE employee_id = 1;

-- Checking if User #1 is an employee, should not be
SELECT *
FROM EMPLOYEE, USER
WHERE employee_id = USER.user_id
AND user_id = 1;

-- Checking USER #21
SELECT N.fname, N.middle_inits, N.lname, U.email, U.phone_no, A.address, A.city, A.state
FROM USER U, NAME N, ADDRESS A
WHERE U.name_id = N.name_id AND U.address_id = A.address_id
AND U.user_id = 21;

-- Deleting USER #21
DELETE FROM USER
WHERE user_id = 21;

-- Checking USER #21 again, should be deleted
SELECT N.fname, N.middle_inits, N.lname, U.email, U.phone_no, A.address, A.city, A.state
FROM USER U, NAME N, ADDRESS A
WHERE U.name_id = N.name_id AND U.address_id = A.address_id
AND U.user_id = 21;

-- Checking USER #1
SELECT N.fname, N.middle_inits, N.lname, U.email, U.phone_no, A.address, A.city, A.state
FROM USER U, NAME N, ADDRESS A
WHERE U.name_id = N.name_id AND U.address_id = A.address_id
AND U.user_id = 1;

-- Deleting USER #1
DELETE FROM USER
WHERE user_id = 1;

-- Checking USER #1 again, should be deleted
SELECT N.fname, N.middle_inits, N.lname, U.email, U.phone_no, A.address, A.city, A.state
FROM USER U, NAME N, ADDRESS A
WHERE U.name_id = N.name_id AND U.address_id = A.address_id
AND U.user_id = 1;

-- Checking USER #200
SELECT N.fname, N.middle_inits, N.lname, U.email, U.phone_no, A.address, A.city, A.state
FROM USER U, NAME N, ADDRESS A
WHERE U.name_id = N.name_id AND U.address_id = A.address_id
AND U.user_id = 200;

-- Deleting USER #200 (Canaan)
DELETE FROM USER
WHERE user_id = 200;

-- Checking USER #200 again, should be deleted
SELECT N.fname, N.middle_inits, N.lname, U.email, U.phone_no, A.address, A.city, A.state
FROM USER U, NAME N, ADDRESS A
WHERE U.name_id = N.name_id AND U.address_id = A.address_id
AND U.user_id = 200;

-- Checking all unused names
SELECT *
FROM NAME
WHERE name_id NOT IN (SELECT N.name_id
                      FROM NAME N, USER U, AUTHOR A
                      WHERE N.name_id = U.name_id OR N.name_id = A.name_id);

-- Deleting all unused names
DELETE FROM NAME
WHERE name_id NOT IN (SELECT N.name_id
                      FROM NAME N, USER U, AUTHOR A
                      WHERE N.name_id = U.name_id OR N.name_id = A.name_id);

-- Checking all unused names again, should be deleted
SELECT *
FROM NAME
WHERE name_id NOT IN (SELECT N.name_id
                      FROM NAME N, USER U, AUTHOR A
                      WHERE N.name_id = U.name_id OR N.name_id = A.name_id);

-- Checking all unused addresses
SELECT *
FROM ADDRESS
WHERE address_id NOT IN (SELECT A.address_id
                      FROM ADDRESS A, USER U, WAREHOUSE W
                      WHERE A.address_id = U.address_id OR A.address_id = W.address_id);

-- Deleting all unused addresses
DELETE FROM ADDRESS
WHERE address_id NOT IN (SELECT A.address_id
                      FROM ADDRESS A, USER U, WAREHOUSE W
                      WHERE A.address_id = U.address_id OR A.address_id = W.address_id);

-- Checking all unused addresses again, should be deleted
SELECT *
FROM ADDRESS
WHERE address_id NOT IN (SELECT A.address_id
                      FROM ADDRESS A, USER U, WAREHOUSE W
                      WHERE A.address_id = U.address_id OR A.address_id = W.address_id);

-- Checking for warehouse #20
SELECT * FROM WAREHOUSE
WHERE warehouse_id = 20;

-- Deleting warehouse #20
DELETE FROM WAREHOUSE
WHERE warehouse_id = 20;

-- Checking for warehouse #20 again, should be empty
SELECT * FROM WAREHOUSE
WHERE warehouse_id = 20;
