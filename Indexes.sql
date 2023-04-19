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




