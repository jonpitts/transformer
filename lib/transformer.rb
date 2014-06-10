require 'singleton'
require 'nokogiri'
require 'erb'
require 'tmpdir'
require 'uuid'
require_relative 'tar'
require_relative 'validate'
require_relative 'make_xml'
require_relative 'mod_tags'

include Util::Tar

class Transformer
  include Singleton
  
  attr_accessor :errors, :data_path, :modsTags
  
  
  #transform excel xml into mods validated xml files
  def transform doc, collection_id, dir, institution

    uniqName = createName collection_id

    errorStore(uniqName,"Owning Institution left blank.") if institution.nil?
    
    tmpdir = Dir.mktmpdir ("#{dir}/")
    xmldoc = Nokogiri::XML::Document.parse(doc)
    
    xmldoc.xpath("//Row").each do |node|
      #get tags from file
      hash = getTags node
      #translate these tags into mods equivalent
      hash = translate hash, uniqName
      
      break if @errors.key?(uniqName)
      
      #make xml - transformation
      xml = makeXML hash, institution
      
      #validate xml against mods
      if validate xml, uniqName
        puts "passes mods validation"
      else
        puts "failed mods validation"
        break
      end
      
      fname = hash["filename"]
      #save the xml generated under filename.xml
      saveXML xml, fname, tmpdir unless fname.nil?
    end
    
    errorStore(uniqName,("Not a valid excel xml file")) if xmldoc.xpath("//Row").length == 0
    
    #create package
    tarball tmpdir, uniqName, dir unless @errors.key?(uniqName)
    FileUtils.rm_r tmpdir

    if @errors.key?(uniqName)
      return 500
    else
      return File.join(dir, "#{uniqName}.tar")
    end
  end
  
  
  #extract all tags from excel generated xml file
  def getTags node
    hash = {} #hash to hold working collection
    
    node.children.each do |child|
      hash.store(child.name,child.inner_text) unless child.name == 'text' #text 
    end
    
    return hash
  end
  
  
  #associate excel xml tag with mods tag
  def translate hash, uniqName
    convertedTags = {}
    
    hash.each do |excelTag, inner_text|
      
      found = false #check if tag is found
      
      modsTags.each do |modTag, dictionary| #check each mods tag
        break if found
        dictionary.each do |definition| #each definition of mods tag
          
          #check for possible sub string
          if (excelTag.length < definition.length)
            smallStr = excelTag
            bigStr = definition
          else
            smallStr = definition
            bigStr = excelTag
          end
          
          #if substring exists then store as new hash element
          if smallStr.downcase.include? bigStr.downcase
            convertedTags.store(modTag, inner_text)
            found = true
          end
        end
      end #end each modsTags
      errorStore(uniqName,"could not associate tag: #{excelTag}") unless found
    end
    convertedTags
  end
  
  
  def saveXML xml, fname, tmpdir
    begin
      if File.extname(fname) == ""
        fname = "#{fname}.xml"
      else
        fname = File.basename(fname, File.extname(fname)) + ".xml"
      end
      puts fname
      fname = File.join(tmpdir, fname)
      puts fname
      file = File.new(fname, 'w')
      file.write(xml)
    ensure
      file.close
    end
  end
  
  
  ##tarball method##
  def tarball tmpdir, fname, dir
    
    begin
      io = tar(tmpdir)
      fname = "#{fname}.tar"
      fname = File.join(tmpdir, fname)
      file = File.new(fname, 'w') 
      file.write(io.string)
    ensure
      file.close
      FileUtils.mv fname, dir
    end
  end
  
  ##remove tarball##
  def remove tarball
    FileUtils.rm tarball if File.exist?(tarball)
  end
  
  #list tarballs
  def listTar
    tarfiles = File.join(data_path, '/', '*.tar')
    Dir.glob(tarfiles)
  end
  
  #hash helper method for errors
  def errorStore key, message
    if errors.key?(key)
      errors[key].push(message)
    else
      errors.store(key,Array.new.push(message))
    end
  end
  
  #remove key from hash
  def errorRemove key
    if errors.key?(key)
      errors.delete(key)
    else
      false
    end
  end
  
  #create uniqName
  def createName collection_id
    if collection_id == nil
      UUID.generate 
    else
      errorRemove collection_id
      tarball = "#{data_path}/#{collection_id}.tar"
      remove tarball
      collection_id
    end
  end
  
end
