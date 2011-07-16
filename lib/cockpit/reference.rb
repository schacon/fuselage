module Cockpit
  class Reference < Base

    attr_accessor :ref, :url, :object, :repo

    def self.find(repo, ref, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Reference.new(get("/repos/#{user}/#{repo}/git/refs/#{ref}").merge(:repo => repo))
    end

    def self.find_all(repo, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      refs = []
      get("/repos/#{user}/#{repo}/git/refs").each { |r| refs << Reference.new(r.merge(:repo => repo)) }
      refs
    end

    def self.create(repo, ref, sha)
      raise AuthenticationRequired unless Api.authenticated
      params = {:ref => ref, :sha => sha}
      user = User.current.login
      Reference.new(post("/repos/#{user}/#{repo}/git/refs", params).merge(:repo => repo))
    end
    
    def create_commit(message, tree, other_parents=[], options={})
      parents = other_parents << self.sha
      Commit.create(self.repo, message, tree, parents, options)
    end
    
    def sha
      object['sha'] if object
    end

    def to_s
      self.ref
    end

  end
end
