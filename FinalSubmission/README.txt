D
Final Submission for CSE 3421 Project
Authors: Canaan Porter + Alex Felderean

Files:
1. Final Report -> PLACEHOLDER.pdf
2. Binary SQlite File -> BitsBooks.sqlite
3. SQL Create File -> CREATE.sql
4. Data Files -> CSV files under DataFiles Directory
5. SQL Queries -> QUERIES.sql
6. Insert/Delete Samples -> INSERT-DELETE.sql

2 Options to generate the database in case of sqlite file failure

1) Run generate_db.sh [recommended]
  a) Navigate to the project directory in your terminal
  b) Run the command: $ sh generate_db.sh @filename.sqlite
    This shell script uses the sqlite3 command line tool
    to generate a new database with the @filename.sqlite
    as the file's name. It pulls the schema, views, and indexes
    from the CREATE.sql file, and reads in all the CSV files 
    from the DataFiles directory
  c) Your sqlite database should now be located in the 
    project directory!

2) Import the Schema and Data Files Manually
  a) Navigate to the project directory in your terminal
  b) Run the sqlite3 tool, creating a new database to work in
  c) Use the following command to generate the schema:
      >> .read CREATE.sql
  d) Set the import mode to csv and the delimiter to ; with
      >> .mode csv
      >> .separator ;
  e) Import each data table to the corresponding table with
      >> .import DataFiles/bb_categories.csv CATEGORY
      >> .import DataFiles/bb_publishers.csv PUBLISHER
      >> .import DataFiles/bb_books.csv BOOK
      >> .import DataFiles/bb_book_categories.csv BOOK_CATEGORY
      >> .import DataFiles/bb_authors.csv AUTHOR
      >> .import DataFiles/bb_written_by.csv WRITTEN_BY
      >> .import DataFiles/bb_users.csv USER
      >> .import DataFiles/bb_orders.csv "ORDER"
      >> .import DataFiles/bb_warehouses.csv WAREHOUSE
      >> .import DataFiles/bb_book_orders.csv BOOK_ORDER
      >> .import DataFiles/bb_warehouse_stock.csv WAREHOUSE_STOCK
      >> .import DataFiles/bb_employees.csv EMPLOYEE
      >>.import DataFiles/bb_addresses.csv ADDRESS
      >> .import DataFiles/bb_names.csv NAME
    f) Quit the sqlite3 tool:
      >> .quit

      