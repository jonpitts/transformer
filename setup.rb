require_relative 'lib/transformer'
require_relative 'lib/model/user'
require_relative 'lib/model/tag'

#setup admin and db

begin
  puts "Running setup script..."
  puts " -- Checking if database exists"
  if File.exists?("#{Dir.pwd}/db.sqlite")
    puts " --- moving #{Dir.pwd}/db.sqlite to db.sqlite.old"
    raise " --- db.sqlite.old already exists." if File.exists?("#{Dir.pwd}/db.sqlite.old")
    FileUtils.mv("#{Dir.pwd}/db.sqlite", "#{Dir.pwd}/db.sqlite.old")
  else
    puts " -- No database to backup"
  end
  puts "Setting up database..."
  DataMapper.auto_upgrade!
  user = User.new(:username => 'admin', :password => 'admin', :admin => true)
  user.save
rescue  => e
  puts e.message
  puts "*** Make sure to back up your database first and move it from folder ***"
end
  puts "Setup complete."