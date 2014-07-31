class Transformer
  
  #set initial modsTags and attribute definitions
  def setTagsDefault
    user = User.first(:username => @user_name)
    if user.tags.count == 0
      @modsTags = 
        { 
          "filename" => ["Filename","file"], #used to associate with file
          "title" => ["Title"],
          "alternative" => ["Alternative_Title"],
          "identifier" => ["IID"],
          "author" => ["Author"],
          "artist" => ["Artist"],
          "personal" => ["Personal"],
          "corporate" => ["Corporate"],
          "dateIssued" => ["Date"],
          "physicalDescription" => ["PhysicalDescription"],
          "genre" => ["Genre"],
          "typeOfResource" => ["TypeOfResource"],
          "note" => ["Description"],
          "topic" => ["Subject"],
          "geographic" => ["Geographic"],
          "physicalLocation" => ["PhysicalLocation"],
          "lcsh" => ["subject-lcsh"],
          "accessCondition" => ["Rights"],
          "dateCreated" => ["Created"],
          "namePartDate" => ["Creator_Dates"],
          "issuance" => ["Issuance"],
          "place" => ["Place"],
          "publisher" => ["Publisher"]
        }
      saveTags user
      userSave user
    else
      loadTags user
    end
  end
  
  def notes
  { 
    "filename" => "used for file creation",
    "title" => "",
    "alternative" => "title",
    "identifier" => "",
    "author" => "name usage=primary",
    "artist" => "name",
    "personal" => "name usage=primary",
    "corporate" => "name",
    "dateIssued" => "originInfo",
    "physicalDescription" => "",
    "genre" => "",
    "typeOfResource" => "",
    "note" => "",
    "topic" => "subject",
    "geographic" => "subject",
    "physicalLocation" => "",
    "lcsh" => "subject authority lcsh",
    "accessCondition" => "",
    "dateCreated" => "originInfo",
    "namePartDate" => "namePart type=date",
    "issuance" => "originInfo",
    "place" => "originInfo",
    "publisher" => "originInfo"
  }
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