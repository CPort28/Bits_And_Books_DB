###
# Class : Book
#
# Used to generate store the B & B database definition of a book
# 
#

class Book
  ##
  # Creates a new book object
  def initialize(isbn, release_year, sales_price, title, pub_id, cat_id)
    @isbn = isbn
    @release_year = release_year
    @sales_price = sales_price
    @title = title
    @pub_id = pub_id
    @cat_id = cat_id
    @popularity_rating = rand(1..100)
  end

  def get_isbn
    @isbn
  end

  def get_book_as_hash
    
  end


end