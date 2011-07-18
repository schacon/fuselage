module Cockpit
  class Tag < Base
    attr_accessor :tag, :sha, :message, :tagger, :object, :url

    # Find a tag
    #
    #   examples:
    #     Tag.find('cockpit', '45f6d8e74e145b910be4e15f67ef3892fe7abb26')
    def self.find(repo, sha, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Tag.new(get("/repos/#{user}/#{repo}/git/tags/#{sha}"))
    end

    # Create a tag
    #
    #
    # Options:
    #  :type,    values: 'commit', 'tree', and 'blob'. default is commit
    #  :tagger
    #     :name
    #     :date
    #     :email
    #
    #   examples:
    #     Tag.create('cockpit', v1.0', 'New tag', '45f6d8e74e145b910be4e15f67ef3892fe7abb26')
    #     
    #     Commit.create('cockpit', v1.0', 'New tag', '45f6d8e74e145b910be4e15f67ef3892fe7abb26', {
    #       :tagger => {:name => 'Corey', :email => 'corey@gitpilot.com'}
    #     })
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
