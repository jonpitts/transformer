class Transformer
  
  #generate xml based on converted hash
  def makeXML convertedHash, institution

      xmlStr = ""
      
      template_file = File.open("lib/templates/layout.erb", 'r').read
      xmlStr += "\n" + ERB.new(template_file).result(binding)
      originStr = "<originInfo>"
      
      convertedHash.each do |tag, inner_text|
        
        origin = nil #originInfo component
        template = nil #other template
        
        case tag
        when 'title'
          template = "lib/templates/title_template.erb"
        when 'alternative'
          template = "lib/templates/title_alt_template.erb"
        when 'identifier'
          template = "lib/templates/iid_template.erb"
        when 'artist'
          template = "lib/templates/artist_template.erb"
        when 'author'
          template = "lib/templates/author_template.erb"
        when 'dateIssued'
          origin = "lib/templates/issued_template.erb"
        when 'physicalDescription'
          template = "lib/templates/physical_desc_template.erb"
        when 'genre'
          template = "lib/templates/genre_template.erb"
        when 'typeOfResource'
          template = "lib/templates/type_of_res_template.erb"
        when 'note'
          template = "lib/templates/description_template.erb"
        when 'subject'
          template = "lib/templates/subject_topic_template.erb"
        when 'geographic'
          template = "lib/templates/subject_geo_template.erb"
        when 'physicalLocation'
          template = "lib/templates/physical_loc_template.erb"
        when 'lcsh'
          template = "lib/templates/subject_lcsh_template.erb"
        end
        
        if template
          template_file = File.open(template, 'r').read
          xmlStr += "\n" + ERB.new(template_file).result(binding)
        elsif origin
          template_file = File.open(origin, 'r').read
          originStr += "\n" + ERB.new(template_file).result(binding)
        end
        
        #template_file = File.open("views/layout.erb", 'r').read
        #ERB.new(template_file).result(binding)
      end
      originStr += "\n</originInfo>"
      xmlStr += originStr #insert originInfo into xmlStr
      xmlStr += "\n</mods>"
      doc = Nokogiri.XML(xmlStr) do |config|
        config.default_xml.noblanks
      end
      xmlStr = doc.to_xml(:indent => 2)
      xmlStr

  end
end