require 'rubygems'
require 'ezcrypto'
require 'digest/sha1'

HASH = 'pes'
KEYFILE_NAME = 'keyfile'

def get_directory_list
  all_dirs = Dir.new('.').entries
  file_list = Array.new
  
  all_dirs.each do |current_dir|
    if !File.directory?(current_dir) && current_dir != __FILE__ && current_dir != KEYFILE_NAME
      file_list.push(current_dir)
    end
  end
  
  file_list
end

def assemble_directory_hash

end

def write_keyfile
  keyfile = File.new(KEYFILE_NAME, 'w')

  get_directory_list.each do |filename|
    keyfile.puts "#{Digest::SHA1.hexdigest(filename)}|#{filename}"
    
    # Rename the file to the hash
    if File.exists?(filename)
      File.rename(filename, Digest::SHA1.hexdigest(filename))
    end
  end

  keyfile.close
end

def encrypt_keyfile(the_key)
  key = EzCrypto::Key.with_password the_key, HASH
  key.encrypt_file(KEYFILE_NAME)
end

def decrypt_keyfile(the_key)
  key = EzCrypto::Key.with_password the_key, HASH
  key.decrypt_file(KEYFILE_NAME, KEYFILE_NAME + '_dec')
end

def hash_filename
  
end

def restore_filenames
  # Make sure the keyfile exists
  if !File.exists?(KEYFILE_NAME + '_dec')
    return false
  end
  
  # Go through the file line by line and do the rename
  File.open(KEYFILE_NAME + '_dec') do |file|
    while current_line = file.gets
      # Magic voodoo here
      File.rename(current_line.split('|')[0], current_line.split('|')[1].chomp)
    end
  end
  
  return true
end

print "Key? "
the_key = gets.chomp

# Determine if encrypting or decrypting
if File.exists?(KEYFILE_NAME)
  puts 'Decrypting keyfile...'
  decrypt_keyfile(the_key)

  if restore_filenames
    puts 'Successfully restored filenames.'
  else
    puts 'Could not restore filenames.'
  end
else
  puts 'Writing keyfile and renaming files...'
  write_keyfile
  encrypt_keyfile(the_key)
end

