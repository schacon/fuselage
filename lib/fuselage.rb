require 'rubygems'
require 'open-uri'
require 'httparty'
require 'pp'
require 'json'

# Core extension stuff
#Dir[File.join(File.dirname(__FILE__), "ext/*.rb")].each { |f| require f }

# Octopi stuff
# By sorting them we ensure that api and base are loaded first on all sane operating systems
Dir[File.join(File.dirname(__FILE__), "fuselage/*.rb")].sort.each { |f| require f }

# Include this into your app so you can access the child classes easier.
# This is the root of all things Octopi.
module Fuselage
  
  def authenticated(token, &block)
    begin
      Api.api = AuthApi.instance
      Api.api.token = token
      Api.authenticated = true
      yield
    ensure
      # Reset authenticated so if we were to do an anonymous call it would Just Work(tm)
      Api.authenticated = false
      Api.api = AnonymousApi.instance
    end
  end
  
end
