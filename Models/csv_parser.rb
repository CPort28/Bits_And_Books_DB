
class CsvParser 

  def initialize(filename)
    @filename = filename
    @columns = 0
    @rows = 0
    @hash_array = []
  end

  def change_file!(filename)
    @filename = filename
    @columns = 0
    @rows = 0
    @hash_array = []
  end

  ##
  # Columns must have unique headers
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
    keys = first_line.split(",")

    # Writing the data into hashes
    lines.each_with_index do |line, line_num|
      hash = {}
      value_array = line.split(",")
      value_array.each_with_index do |value, column|
        hash[keys[column]] = value
      end
      @hash_array.push(hash)
    end
  end

  def get_hash_array
    @hash_array
  end

  def get_column_names
    @hash_array[0].keys
  end

  def drop_columns(column_names)
    column_names.each do |c_name|
      @hash_array.each_with_index do |hash, index|
        hash = hash.except(c_name)
        @hash_array[index] = hash
      end
    end
  end

  def fprint(stream)
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

  def fprint(stream, hash_array)
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

  def remove_index(arr, index_to_exclude)
    arr[0,index_to_exclude].concat(arr[index_to_exclude+1..-1])
  end

  def remove_nil_rows(array, attibute)
    indices_to_remove = []
    array.each_with_index do |hash, index|
      if ["", nil].include?(hash[attibute])
        indices_to_remove.push(index)
      end
    end

    flipped_indices = indices_to_remove.reverse
    flipped_indices.each do |index|
      remove_index(array, index)
    end
    array
  end

end

