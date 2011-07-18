module Fuselage
  class Tree < Base

    attr_accessor :sha, :url, :tree, :path, :mode
    
    # Find a tree
    #
    #   examples:
    #     Tree.find('cockpit', '45f6d8e74e145b910be4e15f67ef3892fe7abb26')
    def self.find(repo, sha, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Commit.new(get("/repos/#{user}/#{repo}/trees/#{sha}"))
    end

    # Create a tree
    #
    # Tree Hash:
    #   :path => 'file',
    #   :mode => '100644',    refer to http://developer.github.com/v3/git/trees/ for modes.
    #   :type => 'commit',    values: 'commit', 'tree', and 'blob'. 
    #   :sha => '45f6d8e74e145b910be4e15f67ef3892fe7abb26'
    #     or 
    #   :content => 'Some UTF-8 Encoded Content'
    #
    # Options:
    #  :type,    values: 'commit', 'tree', and 'blob'. default is commit
    #  :tagger
    #     :name
    #     :date
    #     :email
    #
    def self.create(repo, tree_hashes=[], options={})
      raise AuthenticationRequired unless Api.authenticated
      params = {:tree => tree_hashes }.merge(options)
      user = User.current.login
      Tree.new(post("/repos/#{user}/#{repo}/git/trees", params))
    end
    
  end
end
