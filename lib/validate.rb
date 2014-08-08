class Transformer
  
  #can have issues validating if nokogiri cannot get to external schemas via http
  def validate xmlStr, uniqName
    begin
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
    rescue Exception => e
      errorStore(uniqName,e)
      false
    end
  end
end
