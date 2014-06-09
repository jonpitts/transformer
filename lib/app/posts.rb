#GUI - Post something to service#
post '/' do
  error 400, "Missing Data" unless params['xmlfile']
  error 400, "Missing Data" if params['xmlfile'].empty?
    
  tempfile = params['xmlfile'][:tempfile]
  filename = params['xmlfile'][:filename]

  client = env['REMOTE_ADDR']
  #file_url = "file://#{client}/#{filename.gsub(%r(^/+), '')}"
  
  collection_id = params[:collection_id] unless params[:collection_id].empty?

  #res = Resolver.new tempfile, collection_id, settings.data_path, file_url
  
  tarball = @@transformer.transform tempfile, collection_id, settings.data_path #produces hash of tags and inner_text
  #send_file tarball unless tarball == 500
  redirect '/'
end

post '/createHash' do
  #allow user to create their own MODs mapping
  @@transformer.createHash params
  @@transformer.modsTags.each do |key, value|
    puts "#{key} => #{value}"
  end
  redirect '/'
end
