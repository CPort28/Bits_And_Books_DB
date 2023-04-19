-- CUSTOMER_BOOK_ORDERS VIEW
CREATE VIEW CUSTOMER_BOOK_ORDERS
AS  SELECT O.order_id, O.sale_date, BO.isbn, B.title, B.sales_price,
           BO.quantity, BO.quantity * B.sales_price AS total_spent
    FROM "ORDER" O, BOOK_ORDER BO, BOOK B, USER U
    WHERE U.user_id = 50 AND U.user_id = O.customer_id AND
    O.order_id = BO.order_id AND B.isbn = BO.isbn
    ORDER BY O.sale_date DESC;

-- CUSTOMER_ORDERS VIEW
CREATE VIEW CUSTOMER_ORDERS
AS  SELECT order_id, sale_date, bill_no, sum(quantity) as total_books_purchased, sum(total_spent) as total_price
    FROM (SELECT O.order_id, O.sale_date, O.bill_no, B.sales_price,
        BO.quantity, BO.quantity * B.sales_price AS total_spent
        FROM "ORDER" O, BOOK_ORDER BO, BOOK B, USER U
        WHERE U.user_id = 50 AND U.user_id = O.customer_id AND
        O.order_id = BO.order_id AND B.isbn = BO.isbn)
    GROUP BY order_id
    ORDER BY sale_date DESC;

-- TOTAL_BOOK_SALES VIEW
CREATE VIEW TOTAL_BOOK_SALES
AS  SELECT B.isbn, B.title, N.fname || ' ' || N.middle_inits || '' || N.lname as author_name,
           sum(BO.quantity) as copies_sold, sum(BO.quantity * B.sales_price) as total_revenue
    FROM BOOK_ORDER BO, BOOK B, WRITTEN_BY WB, AUTHOR A, NAME N
    WHERE BO.isbn = B.isbn AND WB.isbn = B.isbn AND
          A.author_id = WB.author_id AND A.name_id = N.name_id
    GROUP BY B.isbn, B.title
    ORDER BY total_revenue DESC;

-- AUTHOR_SALES VIEW
CREATE VIEW AUTHOR_SALES
AS  SELECT N.fname, N.middle_inits, N.lname,
           sum(BO.quantity) as copies_sold, sum(BO.quantity * B.sales_price) as total_revenue
    FROM BOOK_ORDER BO, BOOK B, WRITTEN_BY WB, AUTHOR A, NAME N
    WHERE BO.isbn = B.isbn AND WB.isbn = B.isbn AND
          A.author_id = WB.author_id AND A.name_id = N.name_id
    GROUP BY A.author_id
    ORDER BY total_revenue DESC;

-- WAREHOUSE_INVENTORY VIEW
CREATE VIEW WAREHOUSE_INVENTORY
AS  SELECT W.warehouse_id, WS.isbn, B.title,
           WS.quantity as inventory, WS.quantity * B.sales_price as inventory_value
    FROM WAREHOUSE W, WAREHOUSE_STOCK WS, BOOK B
    WHERE W.warehouse_id = WS.warehouse_id AND B.isbn = WS.isbn;

