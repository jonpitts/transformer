class Transformer
  
  #generate xml based on converted hash
  def makeXML convertedHash, institution
      
      template_file = File.open("lib/templates/layout.erb", 'r').read
      xmlStr = ERB.new(template_file).result(binding)
      doc = Nokogiri.XML(xmlStr,&:noblanks)
      
      convertedHash.each do |tag, inner_text|
        
        case tag
        when 'title'
          node = newNode 'titleInfo', inner_text, doc, nil, 'title', nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'alternative'
          node = newNode 'titleInfo', inner_text, doc, 'alternative', 'title', nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'identifier'
          node = newNode 'identifier', inner_text, doc, 'IID', nil, nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'artist'
          node = newNode 'name', inner_text, doc, 'personal', 'namePart', nil
          role = newNode 'role', 'artist', doc, nil, 'roleTerm', 'text'
          node << role
          parent = doc.at_css('mods')
          parent << node
          
        when 'author'
          node = newNode 'name', inner_text, doc, 'personal', 'namePart', nil
          node['usage'] = 'primary'
          role = newNode 'role', 'author', doc, nil, 'roleTerm', 'text'
          node << role
          parent = doc.at_css('mods')
          parent << node
          
        when 'dateIssued'
          node = newNode 'dateIssued', inner_text, doc, nil, nil, nil
          parent = doc.at_css('originInfo')
          parent << node
          
        when 'physicalDescription'
          parent = doc.at_css('physicalDescription')
          if parent == nil
            node = newNode 'physicalDescription', '', doc, nil, nil, nil
            parent = doc.at_css('mods')
            parent << node
          end
          node = newNode 'form', inner_text, doc, nil, nil, nil
          parent << node
          
        when 'genre'
          node = newNode 'genre', inner_text, doc, nil, nil, nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'typeOfResource'
          node = newNode 'typeOfResource', inner_text, doc, nil, nil, nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'note'
          node = newNode 'note', inner_text, doc, nil, nil, nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'subject'
          node = newNode 'subject', inner_text, doc, nil, 'topic', nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'geographic'
          node = newNode 'subject', inner_text, doc, nil, 'geographic', nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'physicalLocation'
          node = newNode 'physicalLocation', inner_text, doc, nil, nil, nil
          parent = doc.at_css('location')
          parent << node
          
        when 'lcsh'
          node = newNode 'subject', inner_text, doc, nil, 'topic', nil
          parent = doc.at_css('mods')
          parent << node
          
        end

      end

      xmlStr = doc.to_xml(:indent => 2)
      xmlStr

  end
  
  #create basic node and subnode structure
  def newNode tagName, inner_text, doc, type, subTagName, subTagType
    node = Nokogiri::XML::Node.new tagName, doc
    
    if type
      node['type'] = type
    end
    
    if subTagName
      subNode = Nokogiri::XML::Node.new subTagName, doc
      if subTagType
        subNode['type'] = subTagType
      end
      subNode.content = inner_text
      node << subNode
    else
      node.content = inner_text
    end
    node
  end
  
end