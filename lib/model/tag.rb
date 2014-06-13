require 'rubygems'
require 'data_mapper'
require 'dm-sqlite-adapter'


class Tag
  include DataMapper::Resource

  property :id, Serial
  property :tag_name, String
  property :tag_assoc, String
  
  belongs_to :user
end
