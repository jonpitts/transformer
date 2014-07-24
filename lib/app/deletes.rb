#browsers without html 5 do not support delete method - below method is used in gui
post '/remove/:collection_id' do |collection_id|
  package = "#{@@session[@user].data_path}/#{collection_id}.zip"
  error 400, "No such file #{collection_id}.zip" unless File.exist?(package)
  @@session[@user].remove package
  @@session[@user].errorRemove collection_id
  redirect "/", 301
end

post '/delete/:collection_id' do |collection_id|
  error 400, "Entry does not exist: #{collection_id}" unless @@session[@user].errors.key?(collection_id)
  @@session[@user].errorRemove(collection_id)
  redirect "/", 301
end