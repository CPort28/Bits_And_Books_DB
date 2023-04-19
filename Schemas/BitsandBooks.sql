
-- CREATING TABLES
---------------------------------------------------------------------------
CREATE TABLE CATEGORY (
    category_id INTEGER NOT NULL PRIMARY KEY,
    cat_name VARCHAR(20) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE PUBLISHER (
    publisher_id INTEGER NOT NULL PRIMARY KEY,
    pub_name VARCHAR(50) NOT NULL,
    phone_no CHAR(10) NOT NULL,
    email VARCHAR(30) NOT NULL
);

CREATE TABLE BOOK (
    isbn CHAR(13) NOT NULL PRIMARY KEY,
    release_year CHAR(4) NOT NULL,
    sales_price DECIMAL(10,2) NOT NULL,
    title VARCHAR(255) NOT NULL,
    publisher_id INTEGER NOT NULL,
    FOREIGN KEY (publisher_id) REFERENCES PUBLISHER(publisher_id)
);

CREATE TABLE BOOK_CATEGORY (
    isbn CHAR(13) NOT NULL,
    category_id INTEGER NOT NULL,
    FOREIGN KEY (isbn) REFERENCES BOOK(isbn),
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)
);

CREATE TABLE AUTHOR (
    author_id INTEGER NOT NULL PRIMARY KEY,
    name_id INTEGER NOT NULL,
    birth_date DATE,
    death_date DATE,
    FOREIGN KEY (name_id) REFERENCES NAME(name_id)
);

CREATE TABLE NAME (
    name_id INTEGER NOT NULL PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    middle_inits VARCHAR(10)
);

CREATE TABLE WRITTEN_BY (
    author_id INTEGER NOT NULL,
    isbn CHAR(13) NOT NULL,
    FOREIGN KEY(author_id) REFERENCES AUTHOR(author_id),
    FOREIGN KEY(isbn) REFERENCES BOOK(isbn)
);

CREATE TABLE USER (
    user_id INTEGER NOT NULL PRIMARY KEY,
    name_id INTEGER NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_no CHAR(10),
    address_id INTEGER NOT NULL,
    FOREIGN KEY(name_id) REFERENCES NAME(name_id)
    FOREIGN KEY(address_id) REFERENCES ADDRESS(address_id)
);

CREATE TABLE ADDRESS (
    address_id INTEGER NOT NULL PRIMARY KEY,
    address VARCHAR(100) NOT NULL,
    secondary_address VARCHAR(50),
    city VARCHAR(30) NOT NULL,
    state CHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    country CHAR(3) NOT NULL
);

CREATE TABLE "ORDER" (
    order_id INTEGER NOT NULL PRIMARY KEY,
    sale_date DATE NOT NULL,
    bill_no INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES USER (user_id)
);

CREATE TABLE WAREHOUSE (
    warehouse_id INTEGER NOT NULL PRIMARY KEY,
    address_id INTEGER NOT NULL,
    total_capacity INTEGER NOT NULL,
    FOREIGN KEY(address_id) REFERENCES ADDRESS(address_id)
);

CREATE TABLE BOOK_ORDER (
    warehouse_id INTEGER NOT NULL,
    isbn CHAR(13) NOT NULL,
    order_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (warehouse_id) REFERENCES WAREHOUSE (warehouse_id),
    FOREIGN KEY (isbn) REFERENCES BOOK (isbn),
    FOREIGN KEY (order_id) REFERENCES "ORDER" (order_id)
);

CREATE TABLE WAREHOUSE_STOCK (
    isbn CHAR(13) NOT NULL,
    warehouse_id INTEGER NOT NULL,
    quantity INTEGER,
    FOREIGN KEY (isbn) REFERENCES BOOK (isbn),
    FOREIGN KEY (warehouse_id) REFERENCES WAREHOUSE (warehouse_id)
);

CREATE TABLE EMPLOYEE (
    employee_id INTEGER NOT NULL,
    warehouse_id INTEGER,
    position VARCHAR(25) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES USER(user_id),
    FOREIGN KEY (warehouse_id) REFERENCES WAREHOUSE(warehouse_id)
);



-- CREATING VIEWS
---------------------------------------------------------------------------
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



-- CREATING INDEXES
---------------------------------------------------------------------------
-- ADDRESS Indexes
CREATE UNIQUE INDEX IF NOT EXISTS address_id_idx ON ADDRESS(address_id);
CREATE INDEX IF NOT EXISTS state_idx ON ADDRESS(state);

-- AUTHOR Indexes
CREATE UNIQUE INDEX IF NOT EXISTS author_id_idx ON AUTHOR(author_id);
CREATE INDEX IF NOT EXISTS bdate_idx ON AUTHOR(birth_date);

-- BOOK Indexes
CREATE UNIQUE INDEX IF NOT EXISTS isbn_idx ON BOOK(isbn);
CREATE INDEX IF NOT EXISTS release_year_idx ON BOOK(release_year);
CREATE INDEX IF NOT EXISTS price_idx ON BOOK(sales_price);
CREATE INDEX IF NOT EXISTS publisher_idx ON BOOK(publisher_id);

-- BOOK_CATEGORY Indexes
CREATE INDEX IF NOT EXISTS book_cat_isbn_idx ON BOOK_CATEGORY(isbn);
CREATE INDEX IF NOT EXISTS cat_idx ON BOOK_CATEGORY(category_id);

-- BOOK_ORDER Indexes
CREATE INDEX IF NOT EXISTS book_order_warehouse_idx ON BOOK_ORDER(warehouse_id);
CREATE INDEX IF NOT EXISTS book_order_isbn_idx ON BOOK_ORDER(isbn);
CREATE INDEX IF NOT EXISTS book_order_idx ON BOOK_ORDER(order_id);

-- CATEGORY Indexes
-- No indexes for category, as it only contains 9 tuples

-- EMPLOYEE Indexes
CREATE UNIQUE INDEX IF NOT EXISTS employee_index ON EMPLOYEE(employee_id);
CREATE INDEX IF NOT EXISTS emp_warehouse_idx ON EMPLOYEE(warehouse_id);
CREATE INDEX IF NOT EXISTS position_idx ON EMPLOYEE(position);

-- NAME Indexes
CREATE UNIQUE INDEX IF NOT EXISTS name_idx ON NAME(name_id);
CREATE INDEX IF NOT EXISTS lname_idx ON NAME(lname);

-- ORDER Indexes
CREATE UNIQUE INDEX IF NOT EXISTS order_idx ON "ORDER"(order_id);
CREATE INDEX IF NOT EXISTS order_date_idx ON "ORDER"(sale_date);
CREATE INDEX IF NOT EXISTS order_customer_idx ON "ORDER"(customer_id);

-- PUBLISHER Indexes
CREATE UNIQUE INDEX IF NOT EXISTS publisher_id_idx ON PUBLISHER(publisher_id);
CREATE INDEX IF NOT EXISTS publisher_name_idx ON PUBLISHER(pub_name);

-- USER Indexes
CREATE UNIQUE INDEX IF NOT EXISTS user_id_idx ON USER(user_id);
CREATE INDEX IF NOT EXISTS user_name_idx ON USER(name_id);
CREATE INDEX IF NOT EXISTS user_addr_idx ON USER(address_id);
CREATE INDEX IF NOT EXISTS user_email_idx ON USER(email);
CREATE INDEX IF NOT EXISTS user_phone_idx ON USER(phone_no);

-- WAREHOUSE Indexes
CREATE UNIQUE INDEX IF NOT EXISTS warehouse_id_idx ON WAREHOUSE(warehouse_id);
CREATE INDEX IF NOT EXISTS warehouse_addr_idx ON WAREHOUSE(address_id);
CREATE INDEX IF NOT EXISTS warehouse_cap_idx ON WAREHOUSE(total_capacity);

-- WAREHOUSE_STOCK Indexes
CREATE INDEX IF NOT EXISTS warehouse_stk_isbn_idx ON WAREHOUSE_STOCK(isbn);
CREATE INDEX IF NOT EXISTS warehouse_stk_warehouse_idx ON WAREHOUSE_STOCK(warehouse_id);
CREATE INDEX IF NOT EXISTS warehouse_stk_quantity_idx ON WAREHOUSE_STOCK(quantity);

-- WRITTEN_BY Indexes
CREATE INDEX IF NOT EXISTS written_by_isbn_idx ON WRITTEN_BY(isbn);
CREATE INDEX IF NOT EXISTS writteb_by_author_idx ON WRITTEN_BY(author_id);