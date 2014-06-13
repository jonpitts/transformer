require 'rubygems'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'bcrypt'
require_relative 'tag'

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db.sqlite")

class User
  include DataMapper::Resource
  include BCrypt

  property :id, Serial
  property :username, String, :length => 3..50, :key => true
  property :password, BCryptHash
  property :admin, Boolean
  
  has n, :tags
  
  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
  
  def isAdmin?
    return self.admin
  end
  
  def setAdminOn
    self.admin = true
  end
  
  def setAdminOff
    self.admin = false
  end
  
  def changePassword newPassword
    self.password = newPassword
  end
  
end

DataMapper.finalize
DataMapper.auto_upgrade!