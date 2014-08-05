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