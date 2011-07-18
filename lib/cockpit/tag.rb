module Cockpit
  class Tag < Base
    attr_accessor :tag, :sha, :message, :tagger, :object, :url

    def self.find(repo, sha, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Tag.new(get("/repos/#{user}/#{repo}/git/tags/#{sha}"))
    end

    def self.create(repo, tag, message, object, options={})
      raise AuthenticationRequired unless Api.authenticated
      options = {:type => 'commit'}.merge(options)
      params = {:tag => tag, :message => message, :object => object}.merge(options)
      user = User.current.login
      Tag.new(post("/repos/#{user}/#{repo}/git/blobs", params))
    end

    def to_s
      tag
    end

  end
end
