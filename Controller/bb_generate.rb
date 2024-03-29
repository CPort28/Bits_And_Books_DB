
require 'sqlite3'

filename = ARGV[0]
filename = "../db/#{filename}"
db = SQLite3::Database.new(filename)

db.execute <<-SQL
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
    isbn CHAR(13) NOT NULL PRIMARY KEY,
    release_year CHAR(4) NOT NULL,
    sales_price DECIMAL(10,2) NOT NULL,
    title VARCHAR(255) NOT NULL,
    publisher_id INTEGER NOT NULL,
    FOREIGN KEY (publisher_id) REFERENCES PUBLISHER(publisher_id)
  );
SQL

db.execute <<-SQL
  CREATE TABLE BOOK_CATEGORY (
    isbn CHAR(13) NOT NULL,
    category_id INTEGER NOT NULL,
    FOREIGN KEY (isbn) REFERENCES BOOK(isbn),
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)
  );
SQL

db.execute <<-SQL
  CREATE TABLE AUTHOR (
    author_id INTEGER NOT NULL PRIMARY KEY,
    name_id INTEGER NOT NULL,
    birth_date DATE,
    death_date DATE,
    FOREIGN KEY(name_id) REFERENCES NAME(name_id)
  );
SQL

db.execute <<-SQL
  CREATE TABLE NAME (
    name_id INTEGER NOT NULL PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    middle_inits VARCHAR(10)
  );
SQL

db.execute <<-SQL
  CREATE TABLE WRITTEN_BY (
    author_id INTEGER NOT NULL,
    isbn CHAR(13) NOT NULL,
    FOREIGN KEY(author_id) REFERENCES AUTHOR(author_id),
    FOREIGN KEY(isbn) REFERENCES BOOK(isbn)
  );
SQL

db.execute <<-SQL
  CREATE TABLE USER (
    user_id INTEGER NOT NULL PRIMARY KEY,
    name_id INTEGER NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_no CHAR(10),
    address_id INTEGER NOT NULL,
    FOREIGN KEY(name_id) REFERENCES NAME(name_id)
    FOREIGN KEY(address_id) REFERENCES ADDRESS(address_id)
  );
SQL

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
  CREATE TABLE ADDRESS (
    address_id INTEGER NOT NULL PRIMARY KEY,
    address VARCHAR(100) NOT NULL,
    secondary_address VARCHAR(50),
    city VARCHAR(30) NOT NULL,
    state CHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    country CHAR(3) NOT NULL
  );
SQL

db.execute <<-SQL
  CREATE TABLE WAREHOUSE (
    warehouse_id INTEGER NOT NULL PRIMARY KEY,
    address_id INTEGER NOT NULL,
    total_capacity INTEGER NOT NULL,
    FOREIGN KEY(address_id) REFERENCES ADDRESS(address_id)
  );
SQL

db.execute <<-SQL
  CREATE TABLE BOOK_ORDER (
    warehouse_id INTEGER NOT NULL,
    isbn CHAR(13) NOT NULL,
    order_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (warehouse_id) REFERENCES WAREHOUSE (warehouse_id),
    FOREIGN KEY (isbn) REFERENCES BOOK (isbn),
    FOREIGN KEY (order_id) REFERENCES "ORDER" (order_id)
  );
SQL

db.execute <<-SQL
  CREATE TABLE WAREHOUSE_STOCK (
    isbn CHAR(13) NOT NULL,
    warehouse_id INTEGER NOT NULL,
    quantity INTEGER,
    FOREIGN KEY (isbn) REFERENCES BOOK (isbn),
    FOREIGN KEY (warehouse_id) REFERENCES WAREHOUSE (warehouse_id)
  );
SQL

  db.execute <<-SQL
  CREATE TABLE EMPLOYEE (
    employee_id INTEGER NOT NULL,
    warehouse_id INTEGER,
    position VARCHAR(25) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES USER(user_id),
    FOREIGN KEY (warehouse_id) REFERENCES WAREHOUSE(warehouse_id)
  );
SQL
