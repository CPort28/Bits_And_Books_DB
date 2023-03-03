
class CsvGeneratorUtility

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
        file.write(name.to_s + ",")
      else
        file.write(name.to_s + "\n")
      end
    end
  
    # Exporting Data
    hash_array.each_with_index do |entity,i|
      attribute_names.each_with_index do |column,j|
        if j < (attribute_names.length - 1)
          file.write(entity[attribute_names[j]].to_s + ",")
        else
          file.write(entity[attribute_names[j]].to_s + "\n")
        end
      end
    end
  
    file.close
  end


end