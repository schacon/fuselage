module Cockpit
  class Tree < Base

    attr_accessor :sha, :url, :tree, :path, :mode
    
    def self.find(repo, sha, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Commit.new(get("/repos/#{user}/#{repo}/trees/#{sha}"))
    end
    
  end
end