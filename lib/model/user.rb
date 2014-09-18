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
  property :institution, String, :length => 1..20
  property :email, String, :length => 1..50
  
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
  
  def changeEmail newEmail
    self.email = newEmail
  end
  
  def changeInst newInst
    self.institution = newInst
  end
  
end

DataMapper.finalize
#DataMapper.auto_upgrade!
