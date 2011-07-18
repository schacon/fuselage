module Fuselage
  class User < Base

    attr_accessor :company, :name, :following_count, :gravatar_id,
                  :blog, :public_repo_count, :public_gist_count, 
                  :id, :login, :followers_count, :created_at, 
                  :email, :location, :disk_usage, :private_repo_count, 
                  :private_gist_count, :collaborators, :plan, 
                  :owned_private_repo_count, :total_private_repo_count
                  
    
    def self.get_access_token(client_id, client_secret, code)
      responce = Api.api.post('https://github.com/login/oauth/access_token', {:client_id => client_id, :client_secret => client_secret, :code => code})
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


    class << self
      
    end

    def following
      raise AuthenticationRequired unless Api.authenticated
      following = []
      User.get('/user/following').each { |u| following << User.new(u) }
      following
    end

    def followers
      raise AuthenticationRequired unless Api.authenticated
      followers = []
      User.get('/user/followers').each { |u| followers << User.new(u) }
      followers
    end

    # Return repositories for user.
    #
    # Options -
    #   :organization,
    #   :type -> <:all, :public, :private, :member>
    #
    def repositories(options = {})
      options = {:type => :all}.merge(options)
      raise AuthenticationRequired unless Api.authenticated
      repos = []
      if options[:organization].nil?
        User.get('/user/repos', {:type => options[:type].to_s}).each { |r| repos << Repository.new(r) }
      else
        User.get("/orgs/#{options[:organization]}/repos", {:type => options[:type].to_s}).each { |r| repos << Repository.new(r) }
      end
      repos
    end

    # If a user object is passed into a method, we can use this.
    # It'll also work if we pass in just the login.
    def to_s
      login
    end
    
  end
end
