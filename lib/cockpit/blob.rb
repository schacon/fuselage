module Cockpit
  class Blob < Base

    attr_accessor :sha, :content, :encoding

    def self.find(repo, sha, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Blob.new(get("/repos/#{user}/#{repo}/git/blobs/#{sha}"))
    end

    def self.create(repo, content)
      raise AuthenticationRequired unless Api.authenticated
      params = {:content => content, :encoding => 'utf-8'}
      user = User.current.login
      Blob.new(post("/repos/#{user}/#{repo}/git/blobs", params))
    end

  end
end
