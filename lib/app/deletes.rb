#browsers without html 5 do not support delete method - below method is used in gui
post '/remove/:collection_id' do |collection_id|
  tarball = "#{settings.data_path}/#{collection_id}.tar"
  error 400, "No such file #{collection_id}.tar" unless File.exist?(tarball)
  @@transformer.remove tarball
  @@transformer.errorRemove collection_id
  redirect "/", 301
end

post '/delete/:collection_id' do |collection_id|
  error 400, "Entry does not exist: #{collection_id}" unless @@transformer.errors.key?(collection_id)
  @@transformer.errorRemove(collection_id)
  redirect "/", 301
end