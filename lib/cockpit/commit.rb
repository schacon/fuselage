module Cockpit
  class Commit < Base

    attr_accessor :sha, :message, :parents, :author, :url, :tree, :committer

    def self.find(repo, sha, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Commit.new(get("/repos/#{user}/#{repo}/commits/#{sha}"))
    end

    def self.create(repo, message, tree, parents, options={})
      raise AuthenticationRequired unless Api.authenticated
      params = {:message => message, :tree => tree, :parents => parents}.merge(options)
      user = User.current.login
      Commit.new(post("/repos/#{user}/#{repo}/git/commits", params))
    end

  end
end
