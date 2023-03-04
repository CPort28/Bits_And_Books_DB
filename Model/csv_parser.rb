
class CsvParser 

  ##
  # Initializes the CsvParser object
  #
  # @param filename : string
  #   the path and filename that you would like to read (including .csv)
  #
  # @param delimiter : char
  #   the char used to seperate columns in the csv
  #
  # @note :
  #   read_file! must be called after creating an object to finish initializing
  #
  def initialize(filename, delimiter)
    @filename = filename
    @delimiter = delimiter
    @columns = 0
    @rows = 0
    @hash_array = []
  end

  ##
  # Generates a csv file for any dataset
  #
  # @param filename : string
  #   The name of the file you want to generate, must end with ".csv"
  #
  # @param has_array : array(hash)
  #   An array of uniform hashed (same keys) that represent some form of data.
  #   The keys are the attibute names (column headers) and the values get
  #   written to a csv file by hash
  #
  def generate_csv(filename, hash_array)
    file = File.open(filename, "w")
    attribute_names = hash_array[0].keys
    
    # Creating column headers
    attribute_names.each_with_index do |name,i|
      if i < (attribute_names.length - 1)
        file.write(name.to_s + @delimiter)
      else
        file.write(name.to_s + "\n")
      end
    end
  
    # Exporting Data
    hash_array.each_with_index do |entity,i|
      attribute_names.each_with_index do |column,j|
        if j < (attribute_names.length - 1)
          file.write(entity[attribute_names[j]].to_s + @delimiter)
        else
          file.write(entity[attribute_names[j]].to_s + "\n")
        end
      end
    end
  
    file.close
  end

  ##
  # Allows you to change which file you are accessing
  #
  # @param filename : string
  #   the path and filename that you would like to read (including .csv)
  #
  # @modifies :
  #   resets hash_array to [], and changes the filename
  #
  # @requires :
  #   read_file! must be called after changing the file
  #
  def change_file!(filename)
    @filename = filename
    @columns = 0
    @rows = 0
    @hash_array = []
  end

  ##
  # Reads in the given csv file into the CsvParser object
  #
  # @requires :
  #   All columns must have unique names (the first row)
  #
  def read_file!
    # Setting the hash keys to the value of the first row
    begin
      file = File.open(@filename)
    rescue
      print "Error: Failed to open #{@filename}\n"
      exit
    end
    text = file.read
    file.close
    lines = text.split("\n")
    first_line = lines[0]
    lines.shift
    keys = first_line.split(@delimiter)
    @columns = keys.length

    # Writing the data into hashes
    lines.each_with_index do |line, line_num|
      hash = {}
      value_array = line.split(@delimiter)
      value_array.each_with_index do |value, column|
        hash[keys[column]] = value
      end
      @hash_array.push(hash)
      @rows = @rows + 1
    end
  end

  ##
  # Returns the number of columns in the CsvParser object
  #
  def get_column_count
    @columns
  end

  ##
  # Returns the number of rows in the CsvParser object
  #
  def get_row_count
    @rows
  end

  ##
  # Returns the hash array containing the data of the csv
  #
  # Hash array is set up such that
  #   [row1{"attr1" => value, "attr2" => value, ...}, row2{"attr1" => value, "attr2" => value, ...}, ...]
  #
  def get_hash_array
    @hash_array
  end

  ##
  # Returns an array containing the column names of the given csv file
  #
  def get_column_names
    @hash_array[0].keys
  end

  ##
  # Returns an array containing all the values of the given column name
  #
  # @param column_name : string
  #   The identifying key of the column desired
  #
  def get_column(column_name)
    column_array = []
    @hash_array.each do |hash|
      column_array.push({column_name => hash[column_name]})
    end
    column_array
  end

  ##
  # Removes the specified columns from the CsvParser object
  #
  # @param column_names : array(string)
  #
  def drop_columns!(column_names)
    column_names.each do |c_name|
      @hash_array.each_with_index do |hash, index|
        hash = hash.except(c_name)
        @hash_array[index] = hash
      end
    end
  end

  ##
  # Prints the CsvParser object data as a table
  #
  # @param stream : IOStream
  #   The stream that will be written to (defaults to STDOUT)
  #
  def fprint(stream = STDOUT)
    # Printing column headers
    keys = @hash_array[0].keys
    stream.write("1:\t")
    keys.each_with_index do |key, index|
      if index != keys.length - 1
        stream.write("#{key}\t")
      else
        stream.write("#{key}\n")
      end
    end

    i = 2
    # Printing data
    @hash_array.each do |hash|
      stream.write("#{i}:\t")
      hash.each_with_index do |value, index|
        if index != hash.size - 1
          stream.write("#{value}\t")
        else
          stream.write("#{value}\n")
        end
        i = i + 1
      end
    end
  end

  ##
  # Prints the given hash array data as a table
  #
  # @param stream : IOStream
  #   The stream that will be written to (defaults to STDOUT)
  #
  # @param hash_array : array(hash)
  #   The data to be printed
  #
  def fprint(stream = STDOUT, hash_array)
    # Printing column headers
    keys = hash_array[0].keys
    stream.write("1:\t")
    keys.each_with_index do |key, index|
      if index != keys.length - 1
        stream.write("#{key}\t")
      else
        stream.write("#{key}\n")
      end
    end

    i = 2
    # Printing data
    hash_array.each do |hash|
      stream.write("#{i}:\t")
      hash.each_with_index do |value, index|
        if index != hash.size - 1
          stream.write("#{value}\t")
        else
          stream.write("#{value}\n")
        end
        i = i + 1
      end
    end
  end

  ##
  # Returns the given array with the element given by the index removed
  #
  # @param arr : array
  #   The array to remove the index location from
  #
  # @param index_to_exclude : int
  #   The index of the element to be removed from the array
  #
  def remove_index(arr, index_to_exclude)
    arr[0,index_to_exclude].concat(arr[index_to_exclude+1..-1])
  end

  ##
  # Returns an array of hashes containing no nil rows of the given attribute
  #
  # @param array : array(hash)
  #   The array to remove the nil rows from
  #
  # @param attribute : string
  #   The given attribute to check for nil/empty string
  #   
  def remove_nil_rows(array, attibute)
    indices_to_remove = []
    array.each_with_index do |hash, index|
      if ["", nil].include?(hash[attibute])
        indices_to_remove.push(index)
      end
    end

    flipped_indices = indices_to_remove.reverse
    flipped_indices.each do |index|
      array = remove_index(array, index)
    end
    array
  end

end

