require 'rubygems'
require 'ezcrypto'
require 'digest/sha1'

def get_directory_list
  all_dirs = Dir.new('.').entries
  file_list = Array.new
  
  all_dirs.each do |current_dir|
    if !File.directory?(current_dir) && current_dir != __FILE__
      file_list.push(current_dir)
    end
  end
  
  file_list
end

def assemble_directory_hash

end

def write_keyfile
  keyfile = File.new('keyfile', 'w')

  get_directory_list.each do |filename|
    keyfile.puts "#{Digest::SHA1.hexdigest(filename)}|#{filename}"
  end

  keyfile.close
end

def encrypt_keyfile(the_key)
  key = EzCrypto::Key.with_password the_key, "pes"
  key.encrypt_file('keyfile', 'keyfilee', { :suffix => '.kye' })
end

print "Key: "
the_key = gets.chomp

if !write_keyfile
  puts 'Keyfile could not be written.'
else
  puts 'Keyfile written.'
end

if !encrypt_keyfile(the_key)
  puts 'Keyfile could not be encrypted.'
else
  puts 'Keyfile encrypted.'
end
