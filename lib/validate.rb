class Transformer
 
  def validate xmlStr, uniqName
    
    errors = [] #array of errors
    
    xsd = Nokogiri::XML::Schema(File.read(@@schema))
    #doc = Nokogiri::XML.parse(File.read('balancia.xml'))
    
    doc = Nokogiri::XML.parse(xmlStr) do |config|
      config.noblanks
    end
    
    xsd.validate(doc).each do |error|
      puts error.message
      errorStore(uniqName,error)
    end
      
    errors.length == 0 ? (return true) : (return false)
      
  end
end