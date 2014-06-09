class Transformer
  
  #generate xsl based on converted hash
  def makeXML convertedHash

      xmlStr = ""
      
      template_file = File.open("lib/templates/layout.erb", 'r').read
      xmlStr += "\n" + ERB.new(template_file).result(binding)
      
      convertedHash.each do |tag, inner_text|
        
        template = nil
        
        case tag
        when 'title'
          template = "lib/templates/title_template.erb"
        when 'identifier'
          template = "lib/templates/iid_template.erb"
        when 'artist'
          template = "lib/templates/artist_template.erb"
        when 'author'
          template = "lib/templates/author_template.erb"
        when 'dateIssued'
          template = "lib/templates/date_template.erb"
        when 'physicalDescription'
          template = "lib/templates/physical_desc_template.erb"
        when 'genre'
          template = "lib/templates/genre_template.erb"
        when 'typeOfResource'
          template = "lib/templates/type_of_res_template.erb"
        when 'note'
          template = "lib/templates/description_template.erb"
        when 'subject'
          template = "lib/templates/subject_template.erb"
        when 'physicalLocation'
          template = "lib/templates/physical_loc_template.erb"
        end
        
        if template
          template_file = File.open(template, 'r').read
          xmlStr += "\n" + ERB.new(template_file).result(binding)
        end
        #template_file = File.open("views/layout.erb", 'r').read
        #ERB.new(template_file).result(binding)
      end
      
      xmlStr += "\n</mods>"
      
      xmlStr

  end
end