module Cockpit
  class Tree < Base

    attr_accessor :sha, :url, :tree, :path, :mode
    
    def self.find(repo, sha, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Commit.new(get("/repos/#{user}/#{repo}/trees/#{sha}"))
    end

    def self.create(repo, tree_hashes=[], options={})
      raise AuthenticationRequired unless Api.authenticated
      params = {:tree => tree_hashes }.merge(options)
      user = User.current.login
      Tree.new(post("/repos/#{user}/#{repo}/git/trees", params))
    end
    
  end
end
