require 'sinatra/base'

module Sinatra
  module Helpers
    
    def protected!
      return if authorized?
      halt 401, "Not authorized\n"
    end
    
    def authorized?
      if session['user_name'] && User.first(:username => session['user_name']).isAdmin?
        true
      else
        false
      end
    end
    
    def signed_in?
      if session['user_name']
        true
      else
        false
      end
    end
    
  end
end
