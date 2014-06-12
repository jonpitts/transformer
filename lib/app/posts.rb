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
