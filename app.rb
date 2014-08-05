at_exit do
  puts 'exiting transformer...'
  FileUtils.rm_rf(settings.data_path)
end

require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'sinatra'
require 'json'
require_relative 'lib/transformer'
require_relative 'lib/model/user'
require_relative 'lib/model/tag'
require_relative 'lib/helpers/helpers'

#Transformer service for converting excel generated xml into mods format.
#Initial author: Jonathan Pitts, 2014

enable :sessions
@@transformer
@@tmpdir
@@schema = 'mods-3-4.xsd'
@@session = {}

class Login < Sinatra::Base
  
  get "/login" do
    erb :login, :layout => false
  end
  
  post('/login') do
    name = params[:name]
    password = params[:password]
    user = User.first(:username => name)
    error 403, "Failed login: invalid user" unless user
    if user.authenticate password
      session['user_name'] = user.username
      session['user_path'] = Dir.mktmpdir ("#{@@tmpdir}/")
      userTags = user.tags
      @transformer = Transformer.new session['user_path'], session['user_name']
      @@session.store(session['user_name'], @transformer)
      redirect '/'
    else
      session['user_name'] = nil
      error 403, "Failed login: please check your username and password and try again."
    end
    
  end
  
  get '/logout' do
    if session['user_name']
      session.clear
      redirect '/login'
    else
      error 403
    end
    
  end
  
  get '/admin' do
    protected!
    erb :admin, :layout => :layout
  end
  
end

use Login

##sinatra app configuration
configure do
  @@tmpdir = Dir.mktmpdir
  set :environment, :production
  set :data_path, @@tmpdir
  set :views, "#{File.dirname(__FILE__)}/views"
end

before do
  @user = session['user_name']
  redirect '/login' unless @user
end

begin
  load 'lib/app/gets.rb'
  load 'lib/app/posts.rb'
  load 'lib/app/deletes.rb'
  
rescue ScriptError => e
  puts e.message
end