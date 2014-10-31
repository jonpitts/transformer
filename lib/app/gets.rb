# Index view

get '/' do
  erb :index, :layout => false
end

get '/templates' do
  erb :templates, :layout => :layout
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

get '/errors/' do
  content_type 'application/json'
  errors = @@session[@user].errors.to_json
end

get '/packages/' do
  content_type 'application/json'
  packages = @@session[@user].listPackages.to_json
end

get '/old/' do
  erb :content, :layout => :layout
end
