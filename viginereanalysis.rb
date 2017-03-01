require './frequencyanalyzer.rb'

KEY_LENGTH = 6
ALPHABET_LENGTH = 26

if ABBREVIATED.nil?
  if ARGV.last == "-a"
    ARGV.pop
    ABBREVIATED = true
  else
    ABBREVIATED = false
  end
end


file_paths = Array.new

ARGV.each do |arg|
  file_paths << arg
end

def make_offsets(file_paths)
  # Create a hash for each offset position using the same caesar cipher
  offsets = Hash.new("")

  # Fill in offsets
  file_paths.each do |path|
    # Read the file and remove all whitespace
    file = File.read(path).gsub(/\s+/, "")
    # Split the file into uppercase letters
    chars = file.split("").map{ |c| c.upcase }
    # Add the letters to offsets
    chars.each_with_index do |char, index|
      offsets[index % KEY_LENGTH] += char
    end
  end
  offsets
end

# Print each the rankings for each key position
def print_each_cipher_ranking(file_paths)
  offsets = make_offsets(file_paths)
  offsets.keys.each do |key|
    puts "Cipher #{key+1}:"
    print_out_rankings(offsets[key])
  end
end

# Do a reverse viginere with a guessed key
# Actually easier than the last level because each letter only uses caesar
# Just look for most common and associate with e then fidget
def reverse_viginere(cipher_key, file_paths)
  file_paths.each do |file_path|
    puts "For file: #{file_path}"
    plaintext = ""
    # Read the file and split it into individual characters with no whitespace
    chars = File.read(file_path).gsub(/\s+/, "").split("")
    # Translate each character into plaintext based on key position
    chars.each_with_index do |cipher_char, index|
      shift = cipher_key[index % (cipher_key.length)].ord
      # Unshift the cipher character
      plain_char_ord = cipher_char.ord - shift + 'A'.ord # difference is relative
      # Loop around if the ord goes past Z
      plain_char_ord -= ALPHABET_LENGTH if plain_char_ord > 'Z'.ord
      # Come back up if the shift is backwards
      plain_char_ord += 26 if plain_char_ord < 'A'.ord
      # Translate the plain_char_ord into the plain_char
      plain_char = plain_char_ord.chr.downcase
      # Add to the plaintext
      plaintext += plain_char
    end
    puts "The plaintext is: "
    puts plaintext
  end
end
