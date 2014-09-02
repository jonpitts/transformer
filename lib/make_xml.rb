class Transformer
  
  #generate xml based on converted hash
  def makeXML arrayHash, institution
      
      template_file = @layout

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
          
        when 'nonSort'
          node = newNode 'nonSort', inner_text, doc, nil, nil, nil
          parent = doc.at_css('titleInfo')
          if parent == nil
            parent = Nokogiri::XML::Node.new 'titleInfo', doc
            root = doc.at_css('mods')
            root << parent
          end
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
          
        when 'role'
          names = doc.css('name')
          role = newNode 'role', inner_text, doc, nil, 'roleTerm', 'text'
          parent = names.last unless names == nil
          if parent != nil
            parent << role
          else
            name = Nokogiri::XML::Node.new 'name', doc
            name << role
            parent = doc.at_css('mods')
            parent << name
          end   
          
        when 'personal-secondary'
          node = newNode 'name', inner_text, doc, 'personal', 'namePart', nil
          parent = doc.at_css('mods')
          parent << node
          
        when 'dateIssued'
          node = newNode 'dateIssued', inner_text, doc, nil, nil, nil
          parent = doc.at_css('originInfo')
          parent << node
          
        when 'physicalDescription'
          parent = doc.at_css('physicalDescription')
          if parent == nil
            node = Nokogiri::XML::Node.new 'physicalDescription', doc
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
          node = newNode 'typeOfResource', inner_text.downcase, doc, nil, nil, nil
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
        
        when 'namePartDate' #append namePart to last name element added to doc
          node = newNode 'namePart', inner_text, doc, 'date', nil, nil
          names = doc.css('name')
          parent = names.last unless names == nil
          if parent != nil
            parent << node
          else
            name = Nokogiri::XML::Node.new 'name', doc
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
          node = Nokogiri::XML::Node.new 'language', doc
          node << languageTerm
          parent = doc.at_css('mods')
          parent << node
          
        when 'tableOfContents'
          node = newNode 'tableOfContents', inner_text, doc, nil, nil, nil
          parent = doc.at_css('mods')
          parent << node 
        
        when 'physicalExtent'
          parent = doc.at_css('physicalDescription')
          if parent == nil
            node = Nokogiri::XML::Node.new 'physicalDescription', doc
            parent = doc.at_css('mods')
            parent << node
          end
          node = newNode 'extent', inner_text, doc, nil, nil, nil
          parent = doc.at_css('physicalDescription')
          parent << node
        
        when 'abstract'
          node = newNode 'abstract', inner_text, doc, nil, nil, nil
          parent = doc.at_css('mods')
          parent << node
        
        when 'noteType' #add type to last note element added to doc
          #inner_text becomes type attribute in this case
          notes = doc.css('note')
          parent = notes.last unless notes == nil
          if parent != nil
            parent['type'] = inner_text
          else 
            note = newNode 'note', '', doc, inner_text, nil, nil
            name['usage'] = 'primary'
            name << node
            parent = doc.at_css('mods')
            parent << name
          end       
        
        when 'relatedItemTitle'
          relatedItem = Nokogiri::XML::Node.new 'relatedItem', doc
          titleInfo = newNode 'titleInfo', inner_text, doc, nil, 'title', nil
          relatedItem << titleInfo
          root = doc.at_css('mods')
          root << relatedItem
        
        when 'provenance'
          node = newNode 'note', inner_text, doc, 'acquisition', nil, nil
          parent = doc.at_css('mods')
          parent << node
        
        when 'locationUrl'
          node = newNode 'url', inner_text, doc, nil, nil, nil
          parent = doc.at_css('location')
          parent << node
        
        when 'subjectTitle'
          subject = Nokogiri::XML::Node.new 'subject', doc
          title = newNode 'titleInfo', inner_text, doc, nil, 'title', nil
          subject << title
          root = doc.at_css('mods')
          root << subject
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
