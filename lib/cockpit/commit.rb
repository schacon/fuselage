module Cockpit
  class Commit < Base

    attr_accessor :sha, :message, :parents, :author, :url, :tree, :committer

    # Find a commit
    #
    #   examples:
    #     Blob.find('cockpit', '45f6d8e74e145b910be4e15f67ef3892fe7abb26')
    def self.find(repo, sha, user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      Commit.new(get("/repos/#{user}/#{repo}/commits/#{sha}"))
    end

    # Create a commit
    #
    # Options:
    #  :author
    #     :name
    #     :date
    #     :email
    #  :committer
    #     :name
    #     :date
    #     :email
    #
    #   examples:
    #     Commit.create('cockpit', 'This is a new commit', '45f6d8e74e145b910be4e15f67ef3892fe7abb26', ['45f6d8e74e145b910be4e15f67ef3892fe7abb26'])
    #     
    #     Commit.create('cockpit', 'Comit with author', '45f6d8e74e145b910be4e15f67ef3892fe7abb26', ['45f6d8e74e145b910be4e15f67ef3892fe7abb26'], {
    #       :author => {:name => 'Corey', :email => 'corey@gitpilot.com'}
    #     })
    def self.create(repo, message, tree, parents=[], options={})
      raise AuthenticationRequired unless Api.authenticated
      params = {:message => message, :tree => tree, :parents => parents}.merge(options)
      user = User.current.login
      Commit.new(post("/repos/#{user}/#{repo}/git/commits", params))
    end
  
    def merge_attributes(attributes)
      attributes.each do |key, value|
        method = "#{key}="
        self.send(method, value) if respond_to? method
      end
    end

  end
end
