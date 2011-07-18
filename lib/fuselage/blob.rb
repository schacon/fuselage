module Fuselage
  class Blob < Base

    attr_accessor :sha, :content, :encoding

    # Find a blob
    #
    #   examples:
    #     Blob.find('cockpit', '45f6d8e74e145b910be4e15f67ef3892fe7abb26')
    def self.find(repo, sha, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Blob.new(get("/repos/#{user}/#{repo}/git/blobs/#{sha}").merge(:sha => sha))
    end
    
    # Create a blob
    #
    # Content must be in utf-8 encoding.
    # TODO: Add suport for base-64.
    #
    #   examples:
    #     Blob.create('cockpit', 'Some really cool data.')
    def self.create(repo, content)
      raise AuthenticationRequired unless Api.authenticated
      params = {:content => content, :encoding => 'utf-8'}
      user = User.current.login
      Blob.new(post("/repos/#{user}/#{repo}/git/blobs", params))
    end

  end
end
