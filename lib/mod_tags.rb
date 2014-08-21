class Transformer
  
  #set initial modsTags and attribute definitions
  def setTagsDefault
    user = User.first(:username => @user_name)
    if user.tags.count == 0
      @modsTags = 
        { 
          "filename" => ["Filename","file"], #used to associate with file
          "title" => ["Title"],
          "alternative" => ["title-alternative","alternative_title"],
          "identifier" => ["identifier-IID","identifier"],
          "author" => ["Author"],
          "artist" => ["Artist"],
          "personal" => ["name-personal-primary"],
          "personal-secondary" => ["name-personal"],
          "corporate" => ["Corporate"],
          "dateIssued" => ["Date"],
          "physicalDescription" => ["physical-form","format"],
          "genre" => ["Genre"],
          "typeOfResource" => ["type_of_resource"],
          "note" => ["Description"],
          "topic" => ["subject-topic","subject","topic-subject"],
          "geographic" => ["subject-geographic","geographic-subject"],
          "physicalLocation" => ["PhysicalLocation"],
          "lcsh" => ["subject-topic-lcsh","lcsh-subject"],
          "accessCondition" => ["access_condition","rights"],
          "dateCreated" => ["date_created","date-created"],
          "namePartDate" => ["name-personal-primary-date","name-personal-date","creator_dates"],
          "issuance" => ["Issuance"],
          "place" => ["place_of_publication"],
          "publisher" => ["Publisher"],
          "language" => ["Language"],
          "iso-lang" => ["iso-lang"],
          "nonSort" => ["title-nonsort"],
          "tableOfContents" => ["tableOfContents"]
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
    "title" => "&lt;titleInfo&gt;&lt;title&gt;",
    "alternative" => "&lt;titleInfo type=alternative&gt;&lt;title&gt;",
    "identifier" => "&lt;identifier&gt;",
    "author" => "&lt;name usage=primary&gt;&lt;role&gt;&lt;roleTerm&gt;author",
    "artist" => "&lt;name&gt;&lt;role&gt;&lt;roleTerm&gt;artist",
    "personal" => "&lt;name type=personal usage=primary&gt;",
    "personal-secondary" => "&lt;name type=personal&gt;(non primary)",
    "corporate" => "&lt;name type=corporate&gt;",
    "dateIssued" => "&lt;dateIssued&gt;",
    "physicalDescription" => "&lt;physicalDescription&gt;",
    "genre" => "&lt;genre&gt;",
    "typeOfResource" => "&lt;typeOfResource&gt;",
    "note" => "&lt;note&gt;",
    "topic" => "&lt;subject&gt;&lt;topic&gt;",
    "geographic" => "&lt;subject&gt;&lt;geographic&gt;",
    "physicalLocation" => "&lt;physicalLocation&gt;",
    "lcsh" => "&lt;subject authority=lcsh&gt;",
    "accessCondition" => "&lt;accessCondition&gt;",
    "dateCreated" => "&lt;dateCreated&gt;",
    "namePartDate" => "&lt;namePart type=date&gt;",
    "issuance" => "&lt;issuance&gt;",
    "place" => "&lt;place&gt;",
    "publisher" => "&lt;publisher&gt;",
    "language" => "&lt;language&gt;",
    "iso-lang" => "&lt;language&gt;&lt;languageTerm type=code authority=iso&gt;",
    "nonSort" => "&lt;nonSort&gt;",
    "tableOfContents" => "&lt;tableOfContents&gt;"
  }
  end
  
  
end