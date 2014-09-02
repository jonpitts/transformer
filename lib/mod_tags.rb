class Transformer
  
  #set initial modsTags and attribute definitions
  def setTagsDefault
    user = User.first(:username => @user_name)
    if user.tags.count == 0
      @modsTags = 
        { 
          "filename" => ["filename","file"], #used to associate with file
          "title" => ["title"],
          "alternative" => ["title-alternative","alternative_title"],
          "identifier" => ["identifier-IID","identifier"],
          "author" => ["author"],
          "artist" => ["artist"],
          "personal" => ["name-personal-primary"],
          "personal-secondary" => ["name-personal"],
          "corporate" => ["name-corporate"],
          "role" => ["role"],
          "dateIssued" => ["date_issued"],
          "physicalDescription" => ["format","physicalDescription"],
          "genre" => ["genre"],
          "typeOfResource" => ["type_of_resource"],
          "note" => ["description","note"],
          "topic" => ["subject-topic","subject","topic-subject"],
          "geographic" => ["subject-geographic","geographic-subject"],
          "physicalLocation" => ["PhysicalLocation"],
          "lcsh" => ["subject-topic-lcsh","lcsh-subject"],
          "accessCondition" => ["access_condition","rights"],
          "dateCreated" => ["date_created","date-created"],
          "namePartDate" => ["name-personal-primary-date","name-personal-date","creator_dates"],
          "issuance" => ["issuance"],
          "place" => ["place_of_publication"],
          "publisher" => ["publisher"],
          "language" => ["language"],
          "iso-lang" => ["iso-lang"],
          "nonSort" => ["title-nonsort"],
          "tableOfContents" => ["table_of_contents","tableOfContents"],
          "physicalExtent" => ["physicalDescription-extent"],
          "abstract" => ["abstract"],
          "noteType" => ["note_type"],
          "relatedItemTitle" => ["related_item_title"],
          "provenance" => ["provenance"],
          "locationUrl" => ["location_url"],
          "subjectTitle" => ["subject-title"]
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
    "role" => "&lt;role&gt;",
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
    "tableOfContents" => "&lt;tableOfContents&gt;",
    "physicalExtent" => "&lt;extent&gt;",
    "abstract" => "&lt;abstract&gt;",
    "noteType" => "&lt;note type= &gt;",
    "relatedItemTitle" => "&lt;relatedItem&gt;&lt;titleInfo&gt;&lt;title&gt;",
    "provenance" => "&lt;note type=acquisition&gt;",
    "locationUrl" => "&lt;location&gt;&lt;url&gt;",
    "subjectTitle" => "&lt;subject&gt;&lt;titleInfo&gt;&lt;title&gt;"
  }
  end
  
  
end