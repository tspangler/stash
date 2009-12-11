require 'rubygems'
require 'ezcrypto'

def get_directory_list
  all_dirs = Dir.new('.').entries
  file_list = Array.new
  
  all_dirs.each do |current_dir|
    if !File.directory?(current_dir)
      file_list.push(current_dir)
    end
  end
  
  file_list
end

print "Key: "
the_key = gets.chomp

key = EzCrypto::Key.with_password the_key, "pes"
encrypted_content = key.encrypt "At the end of my 80, I'll return to the dirt."

puts encrypted_content

puts 'Decrypting...'
decrypted_content = key.decrypt encrypted_content

puts get_directory_list.inspect