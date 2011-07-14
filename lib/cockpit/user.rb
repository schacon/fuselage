module Cockpit
  class User < Base

    attr_accessor :company, :name, :following_count, :gravatar_id,
                  :blog, :public_repo_count, :public_gist_count, 
                  :id, :login, :followers_count, :created_at, 
                  :email, :location, :disk_usage, :private_repo_count, 
                  :private_gist_count, :collaborators, :plan, 
                  :owned_private_repo_count, :total_private_repo_count, 
                  
                  # These come from search results, which doesn't 
                  # contain the above information.
                  :actions, :score, :language, :followers, :following,
                  :fullname, :type, :username, :repos, :pushed, :created
                  
    
    def self.get_access_token(client_id, client_secret, code)
      responce = Api.api.post('/login/oauth/access_token', {:client_id => client_id, :client_secret => client_secret, :code => code})
      if responce.body != 'error=bad_verification_code'
        access_token = responce.body.match(/\Aaccess_token=(\S+)&/)[1] rescue nil
        return access_token
      end
      raise RegisterError
    end
    
    def self.current
      raise AuthenticationRequired unless Api.authenticated
      User.new(get('/user'))
    end
    
    # Finds a single user identified by the given username
    #
    # Example:
    #   
    #   user = User.find("fcoury")
    #   puts user.login # should return 'fcoury'
    def self.find(username)
      User.new(get("/user/#{username}"))
    end

    # Finds all users whose username matches a given string
    # 
    # Example:
    #
    #   User.find_all("oe") # Matches joe, moe and monroe
    #
    def self.find_all(username)

    end
    
    class << self
      
    end
    
    # If a user object is passed into a method, we can use this.
    # It'll also work if we pass in just the login.
    def to_s
      login
    end
    
  end
end
