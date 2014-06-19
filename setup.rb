require_relative 'lib/transformer'
require_relative 'lib/model/user'
require_relative 'lib/model/tag'

#setup admin and db

begin
  if File.exists?("#{Dir.pwd}/db.sqlite")
    puts "moving #{Dir.pwd}/db.sqlite to db.sqlite.old"
    raise "db.sqlite.old already exists." if File.exists?("#{Dir.pwd}/db.sqlite.old")
    FileUtils.mv("#{Dir.pwd}/db.sqlite", "#{Dir.pwd}/db.sqlite.old")
  else
    puts "no database to backup"
  end
  DataMapper.auto_upgrade!
  user = User.new(:username => 'admin', :password => 'admin', :admin => true)
  user.save
rescue  => e
  puts e.message
  puts "make sure to back up your database first and move it out of folder"
end