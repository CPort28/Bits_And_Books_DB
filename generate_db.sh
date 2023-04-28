sqlite3 $1 <<'END_SQL'
.read CREATE.sql
.mode csv
.separator ;
.import DataFiles/bb_categories.csv CATEGORY
.import DataFiles/bb_publishers.csv PUBLISHER
.import DataFiles/bb_books.csv BOOK
.import DataFiles/bb_book_categories.csv BOOK_CATEGORY
.import DataFiles/bb_authors.csv AUTHOR
.import DataFiles/bb_written_by.csv WRITTEN_BY
.import DataFiles/bb_users.csv USER
.import DataFiles/bb_orders.csv "ORDER"
.import DataFiles/bb_warehouses.csv WAREHOUSE
.import DataFiles/bb_book_orders.csv BOOK_ORDER
.import DataFiles/bb_warehouse_stock.csv WAREHOUSE_STOCK
.import DataFiles/bb_employees.csv EMPLOYEE
.import DataFiles/bb_addresses.csv ADDRESS
.import DataFiles/bb_names.csv NAME
.quit
END_SQL