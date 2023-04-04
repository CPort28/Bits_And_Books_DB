
-- Simple Queries
-- a. Find the titles of all books by Pratchett that cost less than $10
SELECT B.title
FROM BOOK B
JOIN WRITTEN_BY WB on B.isbn = WB.isbn
JOIN AUTHOR A on A.author_id = WB.author_id
JOIN NAME N on A.name_id = N.name_id
WHERE N.lname = 'Pratchett' AND B.sales_price < 10;

-- b. Give all the titles and their dates of purchase
-- made by a single customer (you choose how to designate the customer) (USER_ID = 50)
SELECT B.title, O.sale_date
FROM BOOK B
JOIN BOOK_ORDER BO on B.isbn = BO.isbn
JOIN "ORDER" O ON O.order_id = BO.order_id
JOIN USER U on O.customer_id = U.user_id
WHERE U.user_id = 50;

-- c. Find the titles and ISBNs for all books with less than 5 copies in stock
-- NOTE: only one book has less than 5 in stock (Architecture: Form, Space, and Order)
SELECT B.title, B.isbn, sum(WS.quantity) AS stock
FROM BOOK B
JOIN WAREHOUSE_STOCK WS on B.isbn = WS.isbn
GROUP BY WS.isbn
HAVING sum(WS.quantity) < 5;

-- d. Give all the customers who purchased a book by Pratchett
-- and the titles of Pratchett books they purchased
SELECT NUser.fname, NUser.lname, B.title
FROM NAME NUser
JOIN USER U on NUser.name_id = U.name_id
JOIN "ORDER" on U.user_id = "ORDER".customer_id
JOIN BOOK_ORDER BO on "ORDER".order_id = BO.order_id
JOIN BOOK B on BO.isbn = B.isbn
JOIN WRITTEN_BY WB on B.isbn = WB.isbn
JOIN AUTHOR A on WB.author_id = A.author_id
JOIN NAME NAuth on A.name_id = NAuth.name_id
WHERE NAuth.lname = 'Pratchett';

-- e. Find the total number of books purchased by a single customer
-- (you choose how to designate the customer) (USER_ID = 50)
SELECT U.user_id, N.fname, N.lname, sum(BO.quantity) as books_purchased
FROM USER U
JOIN NAME N on U.name_id = N.name_id
JOIN "ORDER" O on O.customer_id = U.user_id
JOIN BOOK_ORDER BO on O.order_id = BO.order_id
WHERE U.user_id = 50;

-- f. Find the customer who has purchased the most books and
-- the total number of books they have purchased
SELECT U.user_id, N.fname, N.lname, sum(BO.quantity) as books_purchased
FROM USER U
JOIN NAME N on U.name_id = N.name_id
JOIN "ORDER" O on O.customer_id = U.user_id
JOIN BOOK_ORDER BO on O.order_id = BO.order_id
GROUP BY U.user_id, N.fname, N.lname
HAVING books_purchased = (SELECT max(total_books)
                          FROM (SELECT sum(B.quantity) as total_books
                                FROM USER U2
                                JOIN "ORDER" ON U2.user_id = "ORDER".customer_id
                                JOIN BOOK_ORDER B on "ORDER".order_id = B.order_id
                                GROUP BY user_id));

-- Extra Queries
-- 1) Find the author who has sold the most books through B&B
SELECT AName.fname, AName.middle_inits, AName.lname, sum(BO.quantity) as books_sold
FROM AUTHOR A
JOIN NAME AName on A.name_id = AName.name_id
JOIN WRITTEN_BY WB on A.author_id = WB.author_id
JOIN BOOK B on WB.isbn = B.isbn
JOIN BOOK_ORDER BO on B.isbn = BO.isbn
GROUP BY A.author_id
HAVING books_sold = (SELECT max(b_sold)
                     FROM (SELECT sum(BO.quantity) as b_sold
                           FROM AUTHOR A
                           JOIN WRITTEN_BY WB on A.author_id = WB.author_id
                           JOIN BOOK B on WB.isbn = B.isbn
                           JOIN BOOK_ORDER BO on B.isbn = BO.isbn
                           GROUP BY A.author_id));

-- 2) Check which warehouses have enough stock to order 40 copies
-- of a book(given the isbn, “x” (596004478 in this example))
SELECT B.isbn, WAdd.address as warehouse_addr, WAdd.city, WAdd.state, WS.quantity as stock
FROM BOOK B
JOIN WAREHOUSE_STOCK WS on B.isbn = WS.isbn
JOIN WAREHOUSE W on WS.warehouse_id = W.warehouse_id
JOIN ADDRESS WAdd on W.address_id = WAdd.address_id
WHERE B.isbn = 596004478 AND WS.quantity >= 40;

-- 3) Determine the total revenue of the bookstore
SELECT  sum(B.sales_price * BO.quantity) as total_sales
FROM BOOK B
JOIN BOOK_ORDER BO on B.isbn = BO.isbn
JOIN "ORDER" O on BO.order_id = O.order_id;

-- Advanced Queries
-- a. Provide a list of customer names, along with the total dollar amount each customer has spent.
SELECT N.fname, N.lname, sum(B.sales_price * BO.quantity) as total_spent
FROM BOOK B
JOIN BOOK_ORDER BO on B.isbn = BO.isbn
JOIN "ORDER" O on BO.order_id = O.order_id
JOIN USER U on O.customer_id = U.user_id
JOIN NAME N on U.name_id = N.name_id
GROUP BY U.user_id;

-- b. Provide a list of customer names and e-mail addresses for customers who have spent more than the average customer.
SELECT N.fname, N.lname, U.email, sum(B.sales_price * BO.quantity) as total_spent
FROM BOOK B
JOIN BOOK_ORDER BO on B.isbn = BO.isbn
JOIN "ORDER" O on BO.order_id = O.order_id
JOIN USER U on O.customer_id = U.user_id
JOIN NAME N on U.name_id = N.name_id
GROUP BY U.user_id
HAVING total_spent > (SELECT avg(spent_per_c)
                     FROM ( SELECT sum(B.sales_price * BO.quantity) as spent_per_c
                            FROM BOOK B
                            JOIN BOOK_ORDER BO on B.isbn = BO.isbn
                            JOIN "ORDER" O on BO.order_id = O.order_id
                            JOIN USER U on O.customer_id = U.user_id
                            JOIN NAME N on U.name_id = N.name_id
                            GROUP BY U.user_id));

-- c. Provide a list of the titles in the database and associated total copies sold
-- to customers, sorted from the title that has sold the most individual copies to
-- the title that has sold the least.
SELECT B.title, sum(BO.quantity) as copies_sold
FROM BOOK B
JOIN BOOK_ORDER BO on B.isbn = BO.isbn
GROUP BY B.isbn
ORDER BY copies_sold DESC;

-- d. Provide a list of the titles in the database and associated dollar totals for
-- copies sold to customers, sorted from the title that has sold the highest dollar
-- amount to the title that has sold the smallest.
SELECT B.title, sum(BO.quantity * B.sales_price) as dollar_sold_total
FROM BOOK B
JOIN BOOK_ORDER BO on B.isbn = BO.isbn
GROUP BY B.isbn
ORDER BY dollar_sold_total DESC;

-- e. Find the most popular author in the database
-- (i.e. the one who has sold the most books)
SELECT AName.fname, AName.middle_inits, AName.lname, sum(BO.quantity) as books_sold
FROM AUTHOR A
JOIN NAME AName on A.name_id = AName.name_id
JOIN WRITTEN_BY WB on A.author_id = WB.author_id
JOIN BOOK B on WB.isbn = B.isbn
JOIN BOOK_ORDER BO on B.isbn = BO.isbn
GROUP BY A.author_id
HAVING books_sold = (SELECT max(b_sold)
                     FROM (SELECT sum(BO.quantity) as b_sold
                           FROM AUTHOR A
                           JOIN WRITTEN_BY WB on A.author_id = WB.author_id
                           JOIN BOOK B on WB.isbn = B.isbn
                           JOIN BOOK_ORDER BO on B.isbn = BO.isbn
                           GROUP BY A.author_id));

-- f. Find the most profitable author in the database for this store
-- (i.e. the one who has brought in the most money)
SELECT AName.fname, AName.middle_inits, AName.lname, sum(BO.quantity * B.sales_price) as sales_total
FROM AUTHOR A
JOIN NAME AName on A.name_id = AName.name_id
JOIN WRITTEN_BY WB on A.author_id = WB.author_id
JOIN BOOK B on WB.isbn = B.isbn
JOIN BOOK_ORDER BO on B.isbn = BO.isbn
GROUP BY A.author_id
HAVING sales_total = (SELECT max(b_sold)
                     FROM (SELECT sum(BO.quantity * B.sales_price) as b_sold
                           FROM AUTHOR A
                           JOIN WRITTEN_BY WB on A.author_id = WB.author_id
                           JOIN BOOK B on WB.isbn = B.isbn
                           JOIN BOOK_ORDER BO on B.isbn = BO.isbn
                           GROUP BY A.author_id));

-- g. Provide a list of customer information for customers who
-- purchased anything written by the most profitable author in the database.
SELECT UName.fname, UName.lname, U.email, U.phone_no, Ad.address, Ad.city, Ad.state, Ad.country
FROM USER U
JOIN NAME UName on U.name_id = UName.name_id
JOIN ADDRESS Ad on U.address_id = Ad.address_id
JOIN "ORDER" O on U.user_id = O.customer_id
JOIN BOOK_ORDER BO on O.order_id = BO.order_id
JOIN BOOK B on BO.isbn = B.isbn
JOIN WRITTEN_BY WB on B.isbn = WB.isbn
JOIN AUTHOR A on WB.author_id = A.author_id
WHERE A.author_id = (SELECT A.author_id
                    FROM AUTHOR A
                    JOIN NAME AName on A.name_id = AName.name_id
                    JOIN WRITTEN_BY WB on A.author_id = WB.author_id
                    JOIN BOOK B on WB.isbn = B.isbn
                    JOIN BOOK_ORDER BO on B.isbn = BO.isbn
                    GROUP BY A.author_id
                    HAVING sum(BO.quantity * B.sales_price) = (SELECT max(b_sold)
                                         FROM (SELECT sum(BO.quantity * B.sales_price) as b_sold
                                               FROM AUTHOR A
                                               JOIN WRITTEN_BY WB on A.author_id = WB.author_id
                                               JOIN BOOK B on WB.isbn = B.isbn
                                               JOIN BOOK_ORDER BO on B.isbn = BO.isbn
                                               GROUP BY A.author_id)))
GROUP BY U.user_id;

-- h. Provide the list of authors who wrote the books purchased by the customers who have
-- spent more than the average customer.
SELECT AuthName.fname, AuthName.middle_inits, AuthName.lname
FROM BOOK B
JOIN BOOK_ORDER BO on B.isbn = BO.isbn
JOIN WRITTEN_BY WB on B.isbn = WB.isbn
JOIN AUTHOR A on WB.author_id = A.author_id
JOIN NAME AuthName on A.name_id = AuthName.name_id
GROUP BY A.author_id
HAVING sum(B.sales_price * BO.quantity) > (SELECT avg(spent_per_c)
                     FROM ( SELECT sum(B.sales_price * BO.quantity) as spent_per_c
                            FROM BOOK B
                            JOIN BOOK_ORDER BO on B.isbn = BO.isbn
                            JOIN "ORDER" O on BO.order_id = O.order_id
                            JOIN USER U on O.customer_id = U.user_id
                            JOIN NAME N on U.name_id = N.name_id
                            GROUP BY U.user_id));

