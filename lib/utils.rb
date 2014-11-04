require 'rubygems'
require 'fileutils'
require 'zip'

#Utilities module
module Util
  
  module Zipper
    
    # Creates a zip
    # Two parameters: zipfile_name, path to folder of collection to zip
    def zip(zipfile_name, path)
      puts zipfile_name
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zf|
        Dir[File.join(path, "**/*")].each do |file|
          #puts file
          zf.add(File.basename(file), file)
        end
      end
    end
    
  end
  
  module ExcelXML
    
    # call excelXML.jar to convert excel into xml
    #Two parameters: xlsxfile and outputfile
    def excelXML xlsxfile, outputfile, lock
      lock.synchronize do
         `java -jar #{Dir.pwd}/bin/excelXML.jar #{xlsxfile} '#{outputfile}'`
      end
      raise "ERROR :: Could not convert Excel document" unless File.exists?(outputfile)
    end
    
  end
  
end
