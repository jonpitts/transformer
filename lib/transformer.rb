#require 'singleton'
require 'nokogiri'
require 'erb'
require 'tmpdir'
require 'uuid'
require_relative 'utils'
require_relative 'validate'
require_relative 'make_xml'
require_relative 'mod_tags'
require_relative 'admin'
require_relative 'string_num'
require_relative 'user_controller'
require 'thread'

include Util::Zipper
include Util::ExcelXML

class Transformer
#  include Singleton
  
  attr_accessor :errors, :data_path, :modsTags, :user_name, :layout, :nonce
  
  def initialize data_path, user_name, lock
    @user_name = user_name
    @data_path = data_path
    setTagsDefault
    @errors = {}
    @layout = File.open("lib/templates/layout.erb", 'rb').read
    @lock = lock
    @nonce = [] #array of timestamps
  end
  
  #transform excel xml into mods validated xml files
  def transform doc, collection_id, institution

    uniqName = createName collection_id

    errorStore(uniqName,"Owning Institution left blank.") if institution.nil?
    
    tmpdir = Dir.mktmpdir nil, "#{data_path}/"
    
    #convert excel into xml
    exceldoc = convertExcel(doc, uniqName, tmpdir)
    
    if exceldoc
      
      xmldoc = Nokogiri::XML::Document.parse(exceldoc) unless @errors.key?(uniqName)
      
      exceldoc.close
      remove exceldoc.path
      
      xmldoc.xpath("//Row").each do |node|
        next if node.child.nil? #empty row
        #get tags from xml
        array = getTags node
        
        #translate these tags into mods equivalent
        hashArray = translate array, uniqName

        next unless hashArray
        #break if @errors.key?(uniqName)
        
        #make xml - transformation
        xml = makeXML hashArray, institution

        #validate xml against mods
        if validate xml, uniqName
          #puts "passes mods validation"
        else
          #puts "failed mods validation"
        end
        
        #retrieve filename for mods xml file
        fname = hashArray[0]
        fname = fname.values[0]
        
        #save
        saveXML xml, fname, tmpdir unless fname.nil?

      end
      #check if any rows were found
      errorStore(uniqName,("ERROR :: No rows found.")) if xmldoc.xpath("//Row").length == 0
    end
    
    
    #create package
    package tmpdir, uniqName, data_path unless @errors.key?(uniqName)
    FileUtils.rm_r tmpdir

    if @errors.key?(uniqName)
      return 500
    else
      return File.join(data_path, "#{uniqName}.zip")
    end
  end
  
  
  #extract all tags from excel generated xml file
  def getTags node
    array = [] #array to hold working collection
    
    node.children.each do |child|
      array << Hash[child.name,child.inner_text] unless child.name == 'text' #text 
    end
    
    return array
  end
  

  #associate excel xml tag with mods tag - returns false if error was found
  #matches downcase exact and downcase enumerated. ex 'Casper' == 'casper1'
  def translate array, uniqName
    convertedTags = []
    
    errorfound = false
    
    array.each do |hash|
      excelTag = hash.first[0]
      inner_text = hash.first[1]
      found = false #reset found to false
      
      modsTags.each do |modTag, dictionary| #check each mods tag
        break if found
        dictionary.each do |definition| #each definition of mods tag
          
          #assign designations of bigger or smaller string
          if (excelTag.length < definition.length)
            smallStr = excelTag
            bigStr = definition
          else
            smallStr = definition
            bigStr = excelTag
          end
          
          #downcase each string
          bigStr = bigStr.downcase
          smallStr = smallStr.downcase
          
          #if substring exists then check
          if bigStr.include? smallStr
            #check if strings are the same length or if the end is an integer
            if (bigStr.length == smallStr.length) || (bigStr[smallStr.length,bigStr.length].numeric?)
              convertedTags << Hash[modTag, inner_text]
              found = true
            end
          end
        end
      end #end each modsTags
      errorStore(uniqName,"MAP ERROR :: No mapping for tag: #{excelTag}") unless found
      errorfound = true unless found
    end
    if errorfound
      return false
    else
      return convertedTags
    end
  end
  
  #call excel to XML converter
  def convertExcel exceldoc, fname, tmpdir
    uniqName = fname
    begin
      if File.extname(fname) == ""
        fname = "#{fname}.xml"
      else
        fname = File.basename(fname, File.extname(fname)) + ".xml"
      end
      fname = File.join(tmpdir, fname)
      excelXML exceldoc.path, fname, @lock
      File.open(fname)
    rescue Exception => e
      errorStore(uniqName,e.message)
      false
    end
  end
  
  #saveXML to tmpdir
  def saveXML xml, fname, tmpdir
    begin
      if File.extname(fname) == ""
        fname = "#{fname}.xml"
      else
        fname = File.basename(fname, File.extname(fname)) + ".xml"
      end
      fname = File.join(tmpdir, fname)
      file = File.new(fname, 'w')
      file.write(xml)
    ensure
      file.close
    end
  end
  
  
  ##package method##
  def package tmpdir, fname, dir
    
    begin
      fname = "#{fname}.zip"
      fname = File.join(tmpdir, fname)
      puts fname
      zip(fname, tmpdir)
    ensure
      #file.close
      FileUtils.mv fname, dir
    end
  end
  
  ##remove tarball##
  def remove package
    FileUtils.rm package if File.exist?(package)
  end
  
  #list Packages
  def listPackages
    packages = []
    files = File.join(data_path, '/', '*.zip')
    Dir.glob(files).each do |file|
      packages << File.basename(file, ".zip")
    end
    packages
  end
  
  #hash helper method for errors
  def errorStore key, message
    if errors.key?(key)
      errors[key].push(message) unless errors[key].include?(message) #suppress duplicate errors
    else
      errors.store(key,Array.new.push(message))
    end
  end
  
  #remove key from hash or element in array value
  def errorRemove key, index = nil
    if errors.key?(key)
      if index == nil
        errors.delete(key)
      else
        errors[key].delete_at(index.to_i)
        if errors[key].length == 0
          errors.delete(key)
        end
      end
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
      package = "#{data_path}/#{collection_id}.zip"
      remove package
      collection_id
    end
  end
  
end
