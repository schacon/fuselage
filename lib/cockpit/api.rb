require 'singleton'

module Cockpit
  # Dummy class, so AnonymousApi and AuthApi have somewhere to inherit from
  class Api
    attr_accessor :token, :read_only
  end
  
  # Used for accessing the Github API anonymously
  class AnonymousApi < Api
    include HTTParty
    include Singleton
    base_uri "https://api.github.com"
    
    def read_only?
      true
    end
    
    def auth_parameters
      { }
    end
  end
  
  class AuthApi < Api
    include HTTParty
    include Singleton
    base_uri "https://api.github.com"
    
    def read_only?
      false
    end
    
    def auth_parameters
      {:access_token => Api.me.token }
    end
  end
  
  # This is the real API class.
  #
  # API requests are limited to 60 per minute.
  #
  # Sets up basic methods for accessing the API.
  class Api
    @@api = Cockpit::AnonymousApi.instance
    @@authenticated = false
    
    include Singleton
    
    RETRYABLE_STATUS = [403]
    MAX_RETRIES = 5
    # Would be nice if cattr_accessor was available, oh well.
    
    # We use this to check if we use the auth or anonymous api
    def self.authenticated
      @@authenticated
    end
    
    # We set this to true when the user has auth'd.
    def self.authenticated=(value)
      @@authenticated = value
    end
    
    # The API we're using 
    def self.api
      @@api
    end
    
    class << self
      alias_method :me, :api
    end
    
    # set the API we're using
    def self.api=(value)
      @@api = value
    end
  
    def get(path, params = {}, klass=nil)
      resp = self.class.get(path, { :query => params.merge(auth_parameters) })
      raise NotFound, klass || self.class if resp.code.to_i == 404
      raise APIError, 
        "GitHub returned status #{resp.code}" unless resp.code.to_i == 200 || resp.code.to_i == 201
      resp
    end
  
    def post(path, params = {}, klass=nil)
      resp = self.class.post(path, { :query => auth_parameters, :body => params.to_json } )
      raise NotFound, klass || self.class if resp.code.to_i == 404
      raise APIError, 
        "GitHub returned status #{resp.code}" unless resp.code.to_i == 200 || resp.code.to_i == 201
      resp
    end

    private
    
    def method_missing(method, *args)
      api.send(method, *args)
    end
    
  end
end
