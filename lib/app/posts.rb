#GUI - Post something to service#

#ajax post
post '/' do
  #if ajax request
  if request.xhr?
    unless params['xmlfile']
      status 400
      body "Missing filename"
      halt status, body
    end
    
    if params['xmlfile'].empty?
      status 400
      body "Missing Data"
      halt status, body
    end
    
    if params[:institution].empty?
      status 400
      body "Owning institution left blank"
      halt status, body
    end
    
    tempfile = params['xmlfile'][:tempfile]
    filename = params['xmlfile'][:filename]
    
    client = env['REMOTE_ADDR']
    
    collection_id = params[:collection_id] unless params[:collection_id].empty?
    institution = params[:institution] unless params[:institution].empty?
    
    #transform xml into mods
    @@session[@user].transform tempfile, collection_id, institution
    "Process complete"
  else
    "Ajax request not found.  Check your browser settings"
  end

end

#non ajax post method
post '/nonajaxpost' do
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

post '/reset' do
  @@session[@user].reset
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

post '/changePassword' do
  error 400, "Missing user name" unless params[:name]
  error 400, "Missing password" unless params[:password]
  error 400, "Missing new password" unless params[:newPassword]
  error 400, "Missing confirm password" unless params[:confirm]
  
  error 400, "Passwords do not match" unless params[:newPassword] == params[:confirm]
  
  if @@session[@user].changePassword params[:name], params[:password], params[:newPassword]
    redirect '/login'
  else
    error 400, "Incorrect password"
  end
end