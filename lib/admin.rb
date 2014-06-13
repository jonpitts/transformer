class Transformer
  
  #set initial modsTags definitions
  def newUser username, password, admin = false
    puts "creating user: #{username}"
    
    unless User.first(:username => username)
      user = User.new(:username => username, :password => password, :admin => admin)
      userSave user
    else
      false
    end
  end
  
  def updateUser username
    
  end
  
  def removeUser id, username

    puts "Removing user id: #{id}"
    user = User.get(id,username)
    user.destroy unless id == '1'
  end
  
  def setAdmin id, username

    user = User.get(id,username)
    if user.isAdmin?
      if id != '1' && username != user_name
        user.setAdminOff
      end
    else
      user.setAdminOn
    end
    userSave user
  end
  
end