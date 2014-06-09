class Transformer
  
  #set initial modsTags definitions
  def setTagsDefault
    @modsTags = 
        { 
          "filename" => ["Filename","datafile"], #used to associate with file
          "title" => ["Title"],
          "identifier" => ["IID"],
          "artist" => ["Creator"],  #name tag
          "author" => ["Creator2", "Author"], #name tag
          "dateIssued" => ["Date"],
          "physicalDescription" => ["PhysicalDescription"],
          "genre" => ["Genre"],
          "typeOfResource" => ["TypeOfResource"],
          "note" => ["Description"],
          "subject" => ["Subject"],
          "physicalLocation" => ["PhysicalLocation"],
        }
  end
  
  #set user defined hash definitions
  def createHash params
    params.each do |key, value|
      array = value.split(',')
      array.each {|x| x.strip!}
      modsTags[key] = array
    end
  end
end