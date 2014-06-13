#GUI - Post something to service#
post '/' do
  error 400, "Missing Data" unless params['xmlfile']
  error 400, "Missing Data" if params['xmlfile'].empty?
    
  tempfile = params['xmlfile'][:tempfile]
  filename = params['xmlfile'][:filename]

  client = env['REMOTE_ADDR']
  
  collection_id = params[:collection_id] unless params[:collection_id].empty?
  institution = params[:institution] unless params[:institution].empty?
  
  #transform xml into mods
  @@session[@user].transform tempfile, collection_id, institution

  redirect '/'
end

post '/createHash' do
  #allow user to create their own MODs mapping
  @@session[@user].createHash params
  @@session[@user].modsTags.each do |key, value|
    puts "#{key} => #{value}"
  end
  redirect '/'
end

post '/newUser' do
  error 400, "Missing user name" unless params[:name]
  error 400, "Missing password" unless params[:password]
  error 400, "Confirm password" unless params[:confirm]
  error 400, "Passwords do not match" unless params[:password] == params[:confirm]
  
  username = params[:name]
  password = params[:password]
  puts username
  puts password
  if @@session[@user].newUser username, password
    redirect '/admin'
  else
    error 400, "User already exists"
  end
end

post '/setAdmin' do
  error 400, "Missing user id" unless params[:id]
  error 400, "Missing user name" unless params[:name]
  
  username = params[:name]
  id = params[:id]
  @@session[@user].setAdmin id, username
  redirect '/admin'
end

post '/removeUser' do
  error 400, "Missing user id" unless params[:id]
  error 400, "Missing user name" unless params[:name]
  
  username = params[:name]
  id = params[:id]
  @@session[@user].removeUser id, username
  redirect '/admin'
end