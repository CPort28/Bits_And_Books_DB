ruby bb_parser.rb
ruby bb_generate.rb $1
sqlite3 ../db/$1 <<'END_SQL'
.mode csv
.separator ;
.import ../OutputNoHeaders/bb_categories.csv CATEGORY
.import ../OutputNoHeaders/bb_publishers.csv PUBLISHER
.import ../OutputNoHeaders/bb_books.csv BOOK
.import ../OutputNoHeaders/bb_authors.csv AUTHOR
.import ../OutputNoHeaders/bb_written_by.csv WRITTEN_BY
.import ../OutputNoHeaders/bb_users.csv USER
.import ../OutputNoHeaders/bb_orders.csv "ORDER"
.import ../OutputNoHeaders/bb_warehouses.csv WAREHOUSE
.import ../OutputNoHeaders/bb_book_orders.csv BOOK_ORDER
.import ../OutputNoHeaders/bb_warehouse_stock.csv WAREHOUSE_STOCK
.import ../OutputNoHeaders/bb_employees.csv EMPLOYEE
.import ../OutputNoHeaders/bb_addresses.csv ADDRESS
.import ../OutputNoHeaders/bb_names.csv NAME
.quit
END_SQL