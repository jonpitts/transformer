class Transformer
  
  #generate xml based on converted hash
  def makeXML arrayHash, institution
      
      template_file = File.open("lib/templates/layout.erb", 'r').read
      xmlStr = ERB.new(template_file).result(binding)
      doc = Nokogiri.XML(xmlStr,&:noblanks)
      
      arrayHash.each do |hash|

        tag, inner_text = hash.first
        
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
          
        when 'corporate'
          node = newNode 'name', inner_text, doc, 'corporate', 'namePart', nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'personal'
          node = newNode 'name', inner_text, doc, 'personal', 'namePart', nil
          node['usage'] = 'primary'
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
          parent = doc.at_css('physicalDescription')
          node = newNode 'form', inner_text, doc, nil, nil, nil
          parent << node
          
        when 'genre'
          node = newNode 'genre', inner_text, doc, nil, nil, nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'typeOfResource'
          node = newNode 'typeOfResource', inner_text.downcase!, doc, nil, nil, nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'note'
          node = newNode 'note', inner_text, doc, nil, nil, nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'topic'
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
          node['authority'] = 'lcsh'
          parent = doc.at_css('mods')
          parent << node
        
        when 'accessCondition'
          node = newNode 'accessCondition', inner_text, doc, 'use and reproduction', nil, nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'dateCreated'
          node = newNode 'dateCreated', inner_text, doc, nil, nil, nil
          parent = doc.at_css('originInfo')
          parent << node
        
        when 'namePartDate'
          node = newNode 'namePart', inner_text, doc, 'date', nil, nil
          parent = doc.at_css('name[usage=primary]')
          if parent != nil
            parent << node
          else
            name = newNode 'name', '', doc, nil, nil, nil
            name['usage'] = 'primary'
            name << node
            parent = doc.at_css('mods')
            parent << name
          end       
          
        when 'issuance'
          node = newNode 'issuance', inner_text, doc, nil, nil, nil
          parent = doc.at_css('originInfo')
          parent << node
          
        when 'place'
          node = newNode 'place', inner_text, doc, nil, 'placeTerm', 'text'
          parent = doc.at_css('originInfo')
          parent << node
          
        when 'publisher'
          node = newNode 'publisher', inner_text, doc, nil, nil, nil
          parent = doc.at_css('originInfo')
          parent << node
          
        when 'language'
          node = newNode 'language', inner_text, doc, nil, 'languageTerm', 'text'
          parent = doc.at_css('mods')
          parent << node
          
        when 'iso-lang'
          languageTerm = newNode 'languageTerm', inner_text, doc, 'code', nil, nil
          languageTerm['authority']='iso639-2b'
          node = newNode 'language', '', doc, nil, nil, nil
          node << languageTerm
          parent = doc.at_css('originInfo')
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