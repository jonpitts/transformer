class Transformer
  
  #can have issues validating if nokogiri cannot get to external schemas via http
  def validate xmlStr, uniqName
    begin
      errors = [] #array of errors
      @lock.synchronize do
        #use local schemas
        Dir.chdir 'public/schemas/' do
          xsd = Nokogiri::XML::Schema(File.read(@@schema))
          #doc = Nokogiri::XML.parse(File.read('balancia.xml'))
          
          doc = Nokogiri::XML.parse(xmlStr)
          
          xsd.validate(doc).each do |error|
            #puts error.message
            errorStore(uniqName,"VALIDATION ERROR :: #{error}")
          end
        end
      end
      errors.length == 0 ? (return true) : (return false)
    rescue Exception => e
      errorStore(uniqName,"EXCEPTION ERROR :: #{e}")
      false
    end
  end
end
