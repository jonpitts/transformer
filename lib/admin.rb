class Transformer
  
  #admin - new user. set initial modsTags definitions
  def newUser username, password, email, institution, admin = false
    puts "creating user: #{username}"
    
    unless User.first(:username => username)
      user = User.new(:username => username, :password => password, :email => email, :institution => institution, :admin => admin)
      userSave user
    else
      false
    end
  end
  
  #admin - remove user
  def removeUser id, username
    puts "Removing user id: #{id}"
    user = User.get(id,username)
    user.destroy! unless id == '1'
  end
  
  #admin - set institution
  def setInst username, institution
    user = User.first(:username => username)
    user.setInst institution unless institution == ''
    userSave user
  end
  
  #admin - turn admin on or off per user
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
  
  #admin - set password
  def setPassword username, password
    user = User.first(:username => username)
    user.changePassword password
    userSave user
  end
  
end