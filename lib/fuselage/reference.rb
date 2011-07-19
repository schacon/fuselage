module Fuselage
  class Reference < Base

    attr_accessor :ref, :url, :object

    # Find a reference
    #   
    #   ref must have 'heads/' in front of branch name
    #
    #   examples:
    #     Reference.find('cockpit', 'heads/master')
    def self.find(repo, ref, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Reference.new(get("/repos/#{user}/#{repo}/git/refs/#{ref}"))
    end

    # Finds all the refs for a given repo.
    def self.find_all(repo, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      refs = []
      get("/repos/#{user}/#{repo}/git/refs").each { |r| refs << Reference.new(r) }
      refs
    end

    def self.create(repo, ref, sha)
      raise AuthenticationRequired unless Api.authenticated
      params = {:ref => ref, :sha => sha}
      user = User.current.login
      Reference.new(post("/repos/#{user}/#{repo}/git/refs", params))
    end

    def self.update(repo, ref, sha, force=true, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      params = {:force => force, :sha => sha}
      user ||= User.current.login
      Reference.new(post("/repos/#{user}/#{repo}/git/refs/#{ref}", params))
    end

    def self.delete(repo, ref)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      delete_method("/repos/#{user}/#{repo}/git/refs/#{ref}")
    end
    
    def sha
      object['sha'] if object
    end

    def to_s
      ref
    end

  end
end
