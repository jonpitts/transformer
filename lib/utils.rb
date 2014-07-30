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
          puts file
          zf.add(File.basename(file), file)
        end
      end
    end
    
  end
end
