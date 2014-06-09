at_exit do
  puts 'exiting transformer...'
  FileUtils.rm_rf(settings.data_path)
end

require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'sinatra'
require_relative 'lib/transformer'

@@transformer
@@schema = 'mods-3-4.xsd'

##sinatra app configuration
configure do
  #file = ARGV[0]
  tmpdir = Dir.mktmpdir
  set :environment, :production
  set :data_path, tmpdir
  set :views, "#{File.dirname(__FILE__)}/views"
end

begin
  load 'lib/app/gets.rb'
  load 'lib/app/posts.rb'
  load 'lib/app/deletes.rb'
  @@transformer = Transformer.instance
  @@transformer.setTagsDefault
  @@transformer.errors = {}
  @@transformer.errors.store("UUID",[])
  @@transformer.data_path = settings.data_path
rescue ScriptError => e
  puts e.message
end