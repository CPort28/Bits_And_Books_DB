
require_relative '../Model/csv_parser'
require_relative '../Utility/csv_generator_utility'
require 'faker'
require 'date'
Faker::Config.locale = 'en-US'

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

csvGen = CsvGeneratorUtility.new
csvGen.generate_csv("../Output/bb_categories.csv", category_array)

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

csvGen.generate_csv("../Output/bb_publishers.csv", publisher_array)

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

csvGen.generate_csv("../Output/bb_books.csv", books_array)

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

csvGen.generate_csv("../Output/bb_authors.csv", author_array)

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

csvGen.generate_csv("../Output/bb_written_by.csv", written_by_array)