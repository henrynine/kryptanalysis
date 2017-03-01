#check if user wants abbreviated output
if ARGV.last == "-a"
  ARGV.pop
  ABBREVIATED = true
else
  ABBREVIATED = false
end

file_paths = Array.new

ARGV.each do |arg|
  file_paths << arg
end

text = ""

file_paths.each do |path|
  # Read the file and remove all whitespace
  file = File.read(path).gsub(/\s+/, "")
  # Split the file into uppercase letters
  chars = file.split("").map{ |c| c.upcase }
  # Add the letters to the text
  chars.each { |c| text += c }
end

def rank_by_frequency(text)
  # Get all file paths from arguments


  # The default frequency is 0
  frequencies = Hash.new(0)

  # Count the letters in the text
  chars = text.split("").map{ |c| c.upcase }#upcase because ciphertext
  chars.each do |c|
    frequencies[c] += 1
  end

  # Rank letters by frequency

  counts = frequencies.values
  counts = counts.sort.reverse.uniq

  sorted_by_frequency = Array.new

  # Create reverse hash
  reverse_frequencies = Hash.new { |h, k| h[k] = [] }# array default because of duplicates
  frequencies.each do |char, count|
    reverse_frequencies[count] << char
  end

  # Unreverse in sorted order
  counts.each do |count|
    reverse_frequencies[count].each do |c|
      sorted_by_frequency << c
    end
  end
  {sorted: sorted_by_frequency, totals: frequencies}
end

def print_out_rankings(text, abbrev = false)
  ranks = rank_by_frequency(text)
  # Determine output mode
  unless abbrev
    rank_by_frequency(text)[:sorted].each_with_index do |c, index|
      puts "#{index+1}: #{c}, #{rank_by_frequency(text)[:totals][c]}"
    end
  else
    sorted_by_frequency.each do |c|
      print c
    end
    print "\n"
  end
end

print_out_rankings(text, ABBREVIATED)
