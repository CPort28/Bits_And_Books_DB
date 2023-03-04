
require_relative '../Model/csv_parser'
require 'faker'
require 'date'
require 'rubystats'
Faker::Config.locale = 'en-US'


# Config
NUM_CUSTOMERS = 100
NUM_EMPLOYEES = 10
MAX_ORDER_PER_CUSTOMER = 5
MIN_ORDER_PER_CUSTOMER = 0
MAX_DIFF_BOOKS_PER_ORDER = 10
MIN_DIFF_BOOKS_PER_ORDER = 1
MAX_BOOK_ORDER_QUANTITY = 3
MIN_BOOK_ORDER_QUANTITY = 1
WAREHOUSES = 2
START_SALES_DATE = "2010-01-01"
END_SALES_DATE = Date.today
RESERVE_SPACE = 500

def get_author_id(auth_arr, auth_name)
  author = auth_arr.select {|auth_hash| auth_hash["name"] == auth_name}.first
  author["author_id"]
end

# Reading in data from bits and books csv file
filename = "../Data/original_bb_data.csv"
parser = CsvParser.new(filename, ";")
parser.read_file!
parser.get_hash_array
parser.drop_columns!(["nil1", "nil2", "nil3\r"])

# Creating a CSV of Categories
cat_column = parser.get_column("Category")
category_array = []
category_names = []
cat_column.each do |category|
  if !category_names.include?(category["Category"]) && category["Category"] != ""
    category_names.push(category["Category"])
  end
end

category_names.each_with_index do |cat_name, index|
  category_array.push({"category_id" => index + 1, "cat_name" => cat_name, "description" => "N/A"})
end

# FOR TESTING:
# puts category_array

parser.generate_csv("../OutputHeaders/bb_categories.csv", category_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_categories.csv", category_array, 0)

# Creating a Csv of Publishers
publisher_column = parser.get_column("Publisher")
publisher_array = []
publisher_names = []
publisher_column.each do |publisher|
  if !publisher_names.include?(publisher["Publisher"]) && publisher["Publisher"] != ""
    publisher_names.push(publisher["Publisher"])
  end
end

publisher_names.each_with_index do |publisher_name, index|
  pub_id = index + 1
  phone_no = Faker::PhoneNumber.cell_phone.delete("-. ()")
  lowercase_name = publisher_name.downcase
  email = "supply@" + lowercase_name.delete(" ,.") + ".org"
  publisher_array.push({"publisher_id" => pub_id, "pub_name" => publisher_name, "phone_no" => phone_no, "email" => email})
end

# FOR TESTING:
# puts publisher_array

parser.generate_csv("../OutputHeaders/bb_publishers.csv", publisher_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_publishers.csv", publisher_array, 0)

# Creating a CSV of books
books_array = []
data_hash_array = parser.get_hash_array
data_hash_array.each_with_index do |row, index|
  if row["ISBN"] != ""
    isbn = row["ISBN"]
    release_year = row["Year"]
    sales_price = row["Price"].delete("$").to_f
    title = row["Title"]
    publisher_hash = publisher_array.select{|hash| hash["pub_name"] == row["Publisher"]}.first
    pub_id = publisher_hash["publisher_id"]
    cat_hash = category_array.select{|hash| hash["cat_name"] == row["Category"]}.first
    cat_id = cat_hash["category_id"]
    books_array.push({"isbn" => isbn, "release_year" => release_year,"sales_price" => sales_price, "title" => title, "pub_id" => pub_id, "cat_id" => cat_id})
  end
end

# FOR TESTING:
# puts books_array

parser.generate_csv("../OutputHeaders/bb_books.csv", books_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_books.csv", books_array, 0)

# Creating a CSV of authors
author_array = []
author_names = []
data_hash_array.each_with_index do |row, index|
  if !author_names.include?(row["Author(s)"])
    author_names.push(row["Author(s)"])
  end
end

author_names.each_with_index do |author, index|
  author_id = index + 1
  name = author
  split_name = name.split(" ")
  first_name = split_name[0]
  last_name = split_name[split_name.length - 1]
  middle_inits = ""
  if split_name.length > 2
    middle_inits_array = split_name[1, split_name.length - 2]
    middle_inits_array.each_with_index do |init, index|
      if index < middle_inits_array.length - 1
        middle_inits = middle_inits + init + " "
      else
        middle_inits = middle_inits + init
      end
    end
  end

  # Generating appropriate birth dates and death dates
  bdate_start = '1930-01-01'
  bdate_end = '1980-12-31'
  birth_date = Faker::Date.between(from: bdate_start, to: bdate_end)

  ddate_start = '2010-01-01'
  ddate_end = Date.today
  death_date = Faker::Date.between(from: ddate_start, to: ddate_end)

  forty_years_in_days = 365 * 40
  sixty_years_in_days = 365 * 60

  # Getting a possible random death date (could be null based on age)
  days_alive = death_date - birth_date
  dead_prob = rand(0..100)
  if days_alive < forty_years_in_days
    if dead_prob >= 20
      death_date = ""
    end
  elsif days_alive < sixty_years_in_days
    if dead_prob >= 35
      death_date = ""
    end
  else
    if dead_prob >= 65
      death_date = ""
    end
  end

  author_array.push({"author_id" => author_id, "name" => name, "first_name" => first_name, 
    "last_name" => last_name, "middle_inits" => middle_inits, "birth_date" => birth_date, "death_date" => death_date})
end

# FOR TESTING:
# puts author_array

parser.generate_csv("../OutputHeaders/bb_authors.csv", author_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_authors.csv", author_array, 0)

# Generating Written By CSV
written_by_array = []
isbn_written_by = 0
data_hash_array.each_with_index do |row, index|
  # Each time a new book is seen, set the isbn
  if row["ISBN"] != ""
    isbn_written_by = row["ISBN"]
  end

  isbn = isbn_written_by
  author_id = get_author_id(author_array, row["Author(s)"])

  written_by_array.push({"isbn" => isbn, "author_id" => author_id})
end

# FOR TESTING:
# puts written_by_array

parser.generate_csv("../OutputHeaders/bb_written_by.csv", written_by_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_written_by.csv", written_by_array, 0)

# Generating users
user_counter = 1
customer_users_array = []
employee_users_array = []
providers = ["bitsbooks.com"]
for i in 0...NUM_EMPLOYEES
  user_id = user_counter
  user_counter = user_counter + 1
  fname = Faker::Name.first_name
  lname = Faker::Name.last_name
  name = fname + lname
  email = "#{fname}.#{lname}#{rand(0..999)}@#{providers.sample}"
  phone_no = Faker::PhoneNumber.cell_phone.delete("-. ()")
  address = Faker::Address.street_address
  secondary_address = ""
  if rand(1..10) == 1
    secondary_address = Faker::Address.secondary_address
  end
  city = Faker::Address.city
  country = "USA"
  state = Faker::Address.state_abbr
  zip = Faker::Address.postcode
  employee_users_array.push({"user_id" => user_id, "name" => name, "fname" => fname, 
    "lname" => lname, "email" => email, "phone_no" => phone_no, "address" => address, 
    "secondary_address" => secondary_address, "city" => city, "state" => state,
    "zip" => zip, "country" => country})
end

providers = ["gmail.com", "hotmail.com", "yahoo.com"]
for i in 0...NUM_CUSTOMERS
  user_id = user_counter
  user_counter = user_counter + 1
  fname = Faker::Name.first_name
  lname = Faker::Name.last_name
  name = fname + lname
  email = "#{fname}.#{lname}#{rand(0..999)}@#{providers.sample}"
  phone_no = Faker::PhoneNumber.cell_phone.delete("-. ()")
  address = Faker::Address.street_address
  secondary_address = ""
  if rand(1..10) == 1
    secondary_address = Faker::Address.secondary_address
  end
  city = Faker::Address.city
  if rand(1..50) == 1
    country = "CAN"
    possible_regions = ["QC", "ON", "MB", "SK", "AB", "NS", "NB", "NL", "PE", "BC", "YT", "NT", "NU"]
    state = possible_regions.sample
  else
    country = "USA"
    state = Faker::Address.state_abbr
  end
  zip = Faker::Address.postcode
  customer_users_array.push({"user_id" => user_id, "name" => name, "fname" => fname, 
    "lname" => lname, "email" => email, "phone_no" => phone_no, "address" => address, 
    "secondary_address" => secondary_address, "city" => city, "state" => state,
    "zip" => zip, "country" => country})
end

# FOR TESTING:
# puts employee_users_array
# puts customer_users_array

parser.generate_csv("../OutputHeaders/bb_users.csv", employee_users_array + customer_users_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_users.csv", employee_users_array + customer_users_array, 0)

order_counter = 1
bill_numbers = []
order_array = []
# Generating orders
customer_users_array.each_with_index do |customer, index|
  customer_id = customer["user_id"]
  for i in 0..rand(MIN_ORDER_PER_CUSTOMER..MAX_ORDER_PER_CUSTOMER)
    order_id = order_counter
    order_counter = order_counter + 1
    sale_date = Faker::Date.between(from: START_SALES_DATE, to: END_SALES_DATE)
    valid_bill_no = 0
    while valid_bill_no == 0 do
      bill_no = rand(10000..99999)
      if !bill_numbers.include?(bill_no)
        bill_numbers.push(bill_no)
        valid_bill_no = 1
      end
    end
    order_array.push({"order_id" => order_id, "sale_date" => sale_date, "bill_no" => bill_no, 
      "customer_id" => customer_id})
  end
end

# FOR TESTING:
# puts order_array

parser.generate_csv("../OutputHeaders/bb_orders.csv", order_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_orders.csv", order_array, 0)

# Generating Warehouses
warehouse_array = []
for i in 0...WAREHOUSES
  warehouse_id = i + 1
  address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state_abbr
  zip = Faker::Address.postcode
  country = "USA"
  total_capacity = rand(2000..8000)
  warehouse_array.push({"warehouse_id" => warehouse_id, "address" => address, "city" => city, 
    "state" => state, "zip" => zip, "country" => country, "total_capacity" => total_capacity})
end

# FOR TESTING:
# puts warehouse_array

parser.generate_csv("../OutputHeaders/bb_warehouses.csv", warehouse_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_warehouses.csv", warehouse_array, 0)

# Generating Warehouse Stock
warehouse_stock_array = []
warehouse_array.each_with_index do |warehouse, index|
  moving_capacity = warehouse["total_capacity"]
  average_book_stock = (warehouse["total_capacity"] - RESERVE_SPACE) / books_array.length
  book_stock_dev = 50
  norm = Rubystats::NormalDistribution.new(average_book_stock, book_stock_dev)
  books_array.each_with_index do |book, index2|
    isbn = book["isbn"]
    warehouse_id = warehouse["warehouse_id"]
    quantity = norm.rng.to_i.abs
    if moving_capacity < quantity
      quantity = moving_capacity
    end
    warehouse_stock_array.push({"isbn" => isbn, "warehouse_id" => warehouse_id, "quantity" => quantity})
  end
end

# FOR TESTING:
# puts warehouse_stock_array

parser.generate_csv("../OutputHeaders/bb_warehouse_stock.csv", warehouse_stock_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_warehouse_stock.csv", warehouse_stock_array, 0)

# Generating Book Orders
book_order_array = []
order_array.each_with_index do |order, index|
  books_ordered = []
  order_id = order["order_id"]
  warehouse_id = rand(1..WAREHOUSES)
  for i in 0...rand(MIN_DIFF_BOOKS_PER_ORDER..MAX_DIFF_BOOKS_PER_ORDER)
    # selecting book
    unique_book = 0
    while unique_book == 0
      isbn = books_array.sample["isbn"]
      if !books_ordered.include?(isbn)
        unique_book = 1
        books_ordered.push(isbn)
      end
    end
    quantity = rand(MIN_BOOK_ORDER_QUANTITY..MAX_BOOK_ORDER_QUANTITY)
    book_order_array.push({"warehouse_id" => warehouse_id, "isbn" => isbn, "order_id" => order_id, "quantity" => quantity})
  end
end

# FOR TESTING:
# puts book_order_array

parser.generate_csv("../OutputHeaders/bb_book_orders.csv", book_order_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_book_orders.csv", book_order_array, 0)

positions = ["Information Technology", "Human Resources", "Logistics", "Manager", "Transport", "Robotics Engineer"]

# Generating Employees
employee_array = []
employee_users_array.each_with_index do |emp_user, index|
  employee_id = emp_user["user_id"]
  warehouse_id = rand(1..WAREHOUSES)
  position = positions.sample
  employee_array.push({"employee_id" => employee_id, "warehouse_id" => warehouse_id, "position" => position})
end

# FOR TESTING:
# puts employee_array

parser.generate_csv("../OutputHeaders/bb_employees.csv", employee_array, 1)
parser.generate_csv("../OutputNoHeaders/bb_employees.csv", employee_array, 0)