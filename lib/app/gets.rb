# Index view

get '/' do
  erb :index
end

get '/:collection_id' do |collection_id|
  tarball = "#{@@transformer.data_path}/#{collection_id}.tar"
  puts tarball
  error 400, "No such file #{collection_id}.tar" unless File.exist?(tarball)
  send_file tarball
end