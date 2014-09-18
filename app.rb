at_exit do
  puts 'exiting transformer...'
  FileUtils.rm_rf(settings.data_path)
end

require 'tmpdir'
require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'sinatra'
require 'json'
require 'thread'
require_relative 'lib/transformer'
require_relative 'lib/model/user'
require_relative 'lib/model/tag'
require_relative 'lib/helpers/helpers'

#Transformer service for converting excel generated xml into mods format.
#Initial author: Jonathan Pitts, 2014

enable :sessions
@@transformer
@@tmpdir
@@schema = 'mods-3-5.xsd'
@@session = {}
@@workspaces = {}
@@lock = Mutex.new
class Login < Sinatra::Base
  
  get "/login" do
    erb :login, :layout => :layout
  end
  
  post('/login') do
    
    name = params[:name]
    password = params[:password]
    user = User.first(:username => name)
    
    if request.xhr?
      unless user
        status 403
        body "Failed login: invalid user"
        halt status, body
      end
    else
      error 403, "Failed login: invalid user" unless user
    end 
    
    #if user passes authentication
    if user.authenticate password
      #reuse workspace if user has logged in before
      if @@session.has_key? name
        session['user_name'] = name
        session['user_path'] = @@workspaces[name]
      #else create workspace and transformer
      else
        session['user_name'] = user.username
        session['user_path'] = Dir.mktmpdir nil,"#{@@tmpdir}/"
        userTags = user.tags
        @transformer = Transformer.new session['user_path'], session['user_name'], @@lock
        @@session.store(session['user_name'], @transformer)
        @@workspaces.store(session['user_name'], session['user_path'])
      end
                        
      if request.xhr?
        status 200
        body "Login successful"
      else
        redirect '/'
      end
      
    #else if user fails and is ajax
    elsif request.xhr?
      status 403
      body "Failed login: please check your username and password and try again."
      halt status, body
    #else if fails and is not ajax
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