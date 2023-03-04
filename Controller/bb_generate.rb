
require 'sqlite3'

filename = ARGV[0]
filename = "../db/#{filename}"
db = SQLite3::Database.new(filename)

db.execute <<-SQL
  -- Creating Entities
  CREATE TABLE CATEGORY (
    category_id INTEGER NOT NULL PRIMARY KEY,
    cat_name VARCHAR(20) NOT NULL,
    description VARCHAR(255)
  );
SQL

db.execute <<-SQL
  CREATE TABLE PUBLISHER (
    publisher_id INTEGER NOT NULL PRIMARY KEY,
    pub_name VARCHAR(50) NOT NULL,
    phone_no INTEGER(10) NOT NULL,
    email VARCHAR(30) NOT NULL
  );
SQL

db.execute <<-SQL
  CREATE TABLE BOOK (
    isbn VARCHAR(13) NOT NULL PRIMARY KEY,
    release_year INTEGER(4) NOT NULL,
    sales_price DECIMAL(10,2) NOT NULL,
    title VARCHAR(255) NOT NULL,
    publisher_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    FOREIGN KEY (publisher_id) REFERENCES PUBLISHER(publisher_id),
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)
  );
SQL

db.execute <<-SQL
  CREATE TABLE AUTHOR (
    author_id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR (110) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_inits VARCHAR(10),
    birth_date DATE,
    death_date DATE
  );
SQL

db.execute <<-SQL
  CREATE TABLE WRITTEN_BY (
    author_id INTEGER NOT NULL,
    isbn VARCHAR(13) NOT NULL,
    FOREIGN KEY(author_id) REFERENCES AUTHOR(author_id),
    FOREIGN KEY(isbn) REFERENCES BOOK(isbn)
  );
SQL

db.execute <<-SQL
  CREATE TABLE USER (
    user_id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_no INTEGER(10),
    address VARCHAR(100) NOT NULL,
    secondary_address VARCHAR(50),
    city VARCHAR(30) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    country VARCHAR(3) NOT NULL
  );
SQL

  # -- CREATE TABLE PAYMENT (
  # --     bill_no INTEGER NOT NULL PRIMARY KEY,
  # --     sale_date DATE NOT NULL
  # -- );

db.execute <<-SQL
  CREATE TABLE "ORDER" (
    order_id INTEGER NOT NULL PRIMARY KEY,
    sale_date DATE NOT NULL,
    bill_no INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES USER (user_id)
  );
SQL

db.execute <<-SQL
  CREATE TABLE WAREHOUSE (
    warehouse_id INTEGER NOT NULL PRIMARY KEY,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(30) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    country VARCHAR(3) NOT NULL,
    total_capacity INTEGER NOT NULL
  );
SQL

db.execute <<-SQL
  CREATE TABLE BOOK_ORDER (
    warehouse_id INTEGER NOT NULL,
    isbn VARCHAR(13) NOT NULL,
    order_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (warehouse_id) REFERENCES WAREHOUSE (warehouse_id),
    FOREIGN KEY (isbn) REFERENCES BOOK (isbn),
    FOREIGN KEY (order_id) REFERENCES "ORDER" (order_id)
  );
SQL

db.execute <<-SQL
  CREATE TABLE WAREHOUSE_STOCK (
    isbn INTEGER(13) NOT NULL,
    warehouse_id INTEGER NOT NULL,
    quantity INTEGER,
    FOREIGN KEY (isbn) REFERENCES BOOK (isbn),
    FOREIGN KEY (warehouse_id) REFERENCES WAREHOUSE (warehouse_id)
  );
SQL

  # -- CREATE TABLE ACCESS_LEVEL (
  # --     level INTEGER NOT NULL PRIMARY KEY,
  # --     permissions VARCHAR(3) NOT NULL
  # -- );

  db.execute <<-SQL
  CREATE TABLE EMPLOYEE (
    employee_id INTEGER NOT NULL,
    -- access INTEGER NOT NULL,
    warehouse_id INTEGER,
    position VARCHAR(25) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES USER(user_id),
    FOREIGN KEY (warehouse_id) REFERENCES WAREHOUSE(warehouse_id)
    -- FOREIGN KEY (access) REFERENCES ACCESS_LEVEL (level)
  );
SQL
