module Cockpit
  class Reference < Base

    attr_accessor :ref, :url, :object

    def self.find(repo, ref, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Reference.new(get("/repos/#{user}/#{repo}/git/refs/#{ref}"))
    end

    def self.find_all(repo, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      refs = []
      get("/repos/#{user}/#{repo}/git/refs").each { |r| refs << Reference.new(r) }
      refs
    end

    def self.create(repo, message, tree, parents, options={})
      raise AuthenticationRequired unless Api.authenticated
      params = {:message => message, :tree => tree, :parents => parents}.merge(options)
      user = User.current.login
      Reference.new(post("/repos/#{user}/#{repo}/commits", params))
    end

    def to_s
      self.ref
    end

  end
end
