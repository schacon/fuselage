module Cockpit
  class Repository < Base

    attr_accessor :description, :url, :forks, :name, :homepage, :watchers, 
                  :owner, :private, :fork, :open_issues, :pledgie, :size


    # Finds a public repo identified by the given username
    #
    def self.find(repo)
      raise AuthenticationRequired unless Api.authenticated
      Repository.new(get("/repos/#{User.current.login}/#{repo}"))
    end


    # Finds a public repo identified by the given username
    #
    def self.find_by_username(username, repo)
      Repository.new(get("/repos/#{username}/#{repo}"))
    end


    # Finds all public repos identified by the given username
    #
    def self.find_all_by_username(username)
      repos = []
      get("/user/#{username}/repos").each { |r| repos << Repository.new(r) }
      repos
    end

    # Finds all public repos identified by the given organization
    #
    def self.find_by_organization(organization)
      repos = []
      get("/orgs/#{organization}/repos").each { |r| repos << Repository.new(r) }
      repos
    end

    def self.create(name, options={})
      raise AuthenticationRequired unless Api.authenticated
      Repository.new(post('/user/repos', {:name => name}.merge(options)))
    end

    def tags
      raise AuthenticationRequired unless Api.authenticated
      tags = []
      Repository.get("/repos/#{User.current.login}/#{self.name}/tags").each { |t| tags << Tag.new(t) }
      tags
    end

    def branches
      raise AuthenticationRequired unless Api.authenticated
      branches = []
      Repository.get("/repos/#{User.current.login}/#{self.name}/branches").each { |b| branches << Branch.new(b) }
      branches
    end

    def commits(user=nil)
      raise AuthenticationRequired unless Api.authenticated
      user ||= User.current.login
      commits = []
      User.get("/repos/#{user}/#{self.name}/commits").each { |c| commits << Commit.new(c) }
      commits
    end

    def to_s
      name
    end

  end
end
                  
