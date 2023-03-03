
require_relative '../Models/csv_parser'

filename = "../Data/original_bb_data.csv"
parser = CsvParser.new(filename)
parser.read_file!
parser.drop_columns(["nil1", "nil2", "nil3\r"])
data = parser.get_hash_array
author_columns = parser.remove_nil_rows(data, "ISBN")
parser.fprint(STDOUT, author_columns)