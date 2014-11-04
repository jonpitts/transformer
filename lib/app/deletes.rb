#browsers without html 5 do not support delete method - below method is used in gui
post '/remove/:collection_id' do |collection_id|
  package = "#{$session[@user].data_path}/#{collection_id}.zip"
  if File.exist?(package)
    $session[@user].remove package
    $session[@user].errorRemove collection_id
    if request.xhr?
      content_type 'application/json'
      "success"
    else
      redirect '/old/'
    end
  else
    message = "No such file #{collection_id}.zip"
    if request.xhr?
      content_type 'application/json'
      status 400
      body message
      halt status, body
    else
      error 400, message
      redirect "/old/", 301
    end
  end
end

# error delete
post '/delete/:collection_id/:index' do |collection_id, index|
  if $session[@user].errors.key?(collection_id)
    $session[@user].errorRemove(collection_id, index)
    if request.xhr?
      content_type 'application/json'
      "success"
    else
      redirect '/old/'
    end
  else
    if request.xhr?
      content_type 'application/json'
      status 400
      body "Entry does not exist: #{collection_id}"
      halt status, body
    else
      error 400, "Entry does not exist: #{collection_id}"
      halt
    end
  end
end

# delete all errors
post '/delete/:collection_id/' do |collection_id|
  if $session[@user].errors.key?(collection_id)
    $session[@user].errorRemove(collection_id)
    if request.xhr?
      content_type 'application/json'
      "success"
    else
      redirect '/old/'
    end
  else
    if request.xhr?
      content_type 'application/json'
      status 400
      body "Entry does not exist: #{collection_id}"
      halt status, body
    else
      error 400, "Entry does not exist: #{collection_id}"
      halt
    end
  end
end

post '/removeUser' do
  protected!
  error 400, "Missing user id" unless params[:id]
  error 400, "Missing user name" unless params[:name]
  
  username = params[:name]
  id = params[:id]
  $session[@user].removeUser id, username
  redirect '/admin'
end