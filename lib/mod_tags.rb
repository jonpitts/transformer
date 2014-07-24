class Transformer
  
  #set initial modsTags definitions
  def setTagsDefault
    user = User.first(:username => @user_name)
    if user.tags.count == 0
      @modsTags = 
        { 
          "filename" => ["Filename","file"], #used to associate with file
          "title" => ["Title"],
          "identifier" => ["IID"],
          "artist" => ["Creator", "Artist"],  #name tag
          "author" => ["Creator2", "Author"], #name tag
          "dateIssued" => ["Date"],
          "physicalDescription" => ["PhysicalDescription"],
          "genre" => ["Genre"],
          "typeOfResource" => ["TypeOfResource"],
          "note" => ["Description"],
          "subject" => ["Subject"],
          "physicalLocation" => ["PhysicalLocation"],
        }
      saveTags user
      userSave user
    else
      loadTags user
    end
  end
  
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
      #tag.update
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
  
end