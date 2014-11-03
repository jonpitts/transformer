#GUI - Post something to service#
require_relative '../helpers/helpers'

#post file to service
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

    timestamp = params[:timestamp]
    
    #enforce nonce
    if (timestamp.nil?) || ($session[@user].nonce.include? timestamp)
      status 400
      body "Duplicate form submission detected"
      halt status, body
    else
      if $session[@user].nonce.length > 1000
        $session[@user].nonce = [] #reset nonce when it gets too big
      end
      $session[@user].nonce << params[:timestamp]
    end
    
    tempfile = params['xmlfile'][:tempfile]
    filename = params['xmlfile'][:filename]
    
    client = env['REMOTE_ADDR']
    
    collection_id = params[:collection_id] unless params[:collection_id].empty?
    institution = params[:institution] unless params[:institution].empty?
    
    #transform xml into mods
    $session[@user].transform tempfile, collection_id, institution
    "Process complete"
  #handle non ajax requests
  else
    error 400, "Missing Data" unless params['xmlfile']
    error 400, "Missing Data" if params['xmlfile'].empty?
    
    tempfile = params['xmlfile'][:tempfile]
    filename = params['xmlfile'][:filename]
    
    client = env['REMOTE_ADDR']
    
    collection_id = params[:collection_id] unless params[:collection_id].empty?
    institution = params[:institution] unless params[:institution].empty?
    
    #transform xml into mods
    Thread.new{$session[@user].transform tempfile, collection_id, institution}
    
    redirect '/old/'
  end

end

#allow user to create their own MODs mapping
post '/createHash' do
  #if ajax
  params = @params
  if request.xhr?
    content_type 'application/json'
    params = JSON.parse(request.body.read)
    $session[@user].createHash params
    "MODS mapping updated."
  else
    $session[@user].createHash params
    $session[@user].modsTags.each do |key, value|
      #puts "#{key} => #{value}"
    end
    redirect '/old/'
  end
end

post '/reset' do
  $session[@user].reset
  redirect '/'
end

post '/newUser' do
  protected!
  error 400, "Missing user name" unless params[:name]
  error 400, "Missing password" unless params[:password]
  error 400, "Confirm password" unless params[:confirm]
  error 400, "Passwords do not match" unless params[:password] == params[:confirm]
  
  username = params[:name]
  password = params[:password]

  if $session[@user].newUser username, password
    redirect '/admin'
  else
    error 400, "User already exists"
  end
end

post '/setAdmin' do
  protected!
  error 400, "Missing user id" unless params[:id]
  error 400, "Missing user name" unless params[:name]
  
  username = params[:name]
  id = params[:id]
  $session[@user].setAdmin id, username
  redirect '/admin'
end

post '/setPassword' do
  protected!
  error 400, "Missing user name" unless params[:name]
  error 400, "Missing password" unless params[:password]
  error 400, "Cannot change admin password this way" if params[:id] == '1'
  
  $session[@user].setPassword params[:name], params[:password]
  redirect '/admin'
end

post '/changePassword' do
  error 400, "Missing password" unless params[:password]
  error 400, "Missing new password" unless params[:newPassword]
  error 400, "Missing confirm password" unless params[:confirm]
  error 400, "Passwords do not match" unless params[:newPassword] == params[:confirm]
  
  if $session[@user].changePassword user, params[:password], params[:newPassword]
    redirect '/login'
  else
    error 400, "Incorrect password"
  end
  
end

post '/changeSettings' do
  email = params[:email]
  institution = params[:institution]
  $session[@user].changeSettings user, email, institution
  redirect '/user'
end

