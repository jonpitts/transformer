require 'rubygems'
require 'fileutils'
require 'zip'
#require 'debugger'
#Utilities module

module Util
  
  module Zipper
    
    # Creates a zip
    # Two parameters: zipfile_name, path to folder of collection to zip
    def zip(zipfile_name, path)
      puts zipfile_name
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zf|
        Dir[File.join(path, "**/*")].each do |file|
          puts file
          zf.add(File.basename(file), file)
        end
      end
    end
    
  end
  
  module ExcelXML
    
    # call excelXML.jar to convert excel into xml
    #Two parameters: xlsxfile and outputfile
    def excelXML xlsxfile, outputfile
      #debugger
      Dir.chdir(Dir.pwd + "/bin/") do
        system("java -jar excelXML.jar #{xlsxfile} #{outputfile}")
      end
      raise "Could not convert excel document" unless File.exists?(outputfile)
    end
    
  end
  
end
