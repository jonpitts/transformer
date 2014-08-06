# Index view

get '/' do
  erb :index, :layout => :layout
end

get '/user' do
  erb :user, :layout => :layout
end

get '/:collection_id' do |collection_id|
  package = "#{@@session[@user].data_path}/#{collection_id}.zip"
  puts package
  error 400, "No such file #{collection_id}.zip" unless File.exist?(package)
  send_file package
end

#json test
get '/mods/' do
  content_type 'application/json'
  tags = @@session[@user].modsTags.to_json
end

get '/notes/' do
  content_type 'application/json'
  notes = @@session[@user].notes.to_json
end

get '/test/' do
  erb :test, :layout => false
end
