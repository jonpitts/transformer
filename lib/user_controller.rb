class Transformer
  
#user controller
  
  #save user changes
  def userSave user
    user.transaction do |t|
      begin
        user.save
      rescue Exception => e
        t.rollback
        puts e.message
      end
    end
  end
  
  def changePassword user, password, newPassword
    if user.authenticate password
      user.changePassword newPassword
      userSave user
    else
      false
    end
  end
  
  def changeSettings user, email, institution
    user.changeEmail email unless email == ''
    user.changeInst institution unless institution == ''
    userSave user
  end
  
  #user tag controllers
  
  #set user defined hash definitions
  def createHash params
    params.each do |key, value|
      array = value.split(',')
      array.each {|x| x.strip!}
      modsTags[key] = array
    end
    user = User.first(:username => @user_name)
    updateTags user
  end
  
  #save user tags - for new user and tags
  def saveTags user
    puts 'saving tags'
    @modsTags.each do |modtag, modassoc|
      tag = Tag.new(:tag_name => modtag, :tag_assoc => modassoc)
      user.tags << tag
    end
  end
  
  #update user tags
  def updateTags user
    puts 'updating tags'
    @modsTags.each do |modtag, modassoc|
      tag =  user.tags.first(:tag_name => modtag)
      tag.update(:tag_assoc => modassoc)
    end
  end
  
  #load saved user tags
  def loadTags user
    puts 'loading tags'
    @modsTags = {}
    user.tags.each do |tag|
      tag_name = tag.tag_name
      tag_assoc = tag.tag_assoc.gsub(/[\[\"\ \]]/,'').split(',')
      puts "#{tag_assoc}"
      @modsTags.store(tag_name,tag_assoc)
    end
  end
  
  #reset saved tags to default
  def reset
    user = User.first(:username => @user_name)
    puts 'deleting tags'
    user.tags.all.destroy
    puts 'loading default tags'
    setTagsDefault
  end
  
end
