module Fuselage
  class Repository < Base

    attr_accessor :description, :url, :forks, :name, :homepage, :watchers, 
                  :owner, :private, :fork, :open_issues, :pledgie, :size


    # Finds a repo with current authenticated user
    #
    def self.find(repo, options={})
      options = {:type => 'all'}.merge(options)
      if options[:user]
        Repository.new(get("/repos/#{options[:user]}/#{repo}", {:type => options[:type]}))
      else
        raise AuthenticationRequired unless Api.authenticated
        Repository.new(get("/repos/#{User.current.login}/#{repo}", {:type => options[:type]}))
      end
    end

    # Finds all public repos identified by the given username
    #
    def self.find_all(options={})
      options = {:type => 'all'}.merge(options)
      repos = []
      if options[:user]
        get("/users/#{options[:user]}/repos", {:type => options[:type]}).each { |r| repos << Repository.new(r) }
      else
        raise AuthenticationRequired unless Api.authenticated
        get("/user/repos", {:type => options[:type]}).each { |r| repos << Repository.new(r) }
      end
      repos
    end

    # Finds all public repos identified by the given organization
    #
    def self.find_by_organization(organization, options={})
      options = {:type => 'all'}.merge(options)
      repos = []
      get("/orgs/#{organization}/repos", {:type => options[:type]}).each { |r| repos << Repository.new(r) }
      repos
    end

    def self.create(name, options={})
      raise AuthenticationRequired unless Api.authenticated
      Repository.new(post('/user/repos', {:name => name}.merge(options)))
    end

    def tags
      raise AuthenticationRequired unless Api.authenticated
      tags = []
      Repository.get("/repos/#{User.current.login}/#{self.name}/tags").each do |t| 
        tag = Tag.new
        tag.tag = t['name']
        if t['commit']
          tag.object = t['commit']
          tag.object['type'] = 'commit'
        end
        tags << tag
      end
      tags
    end

    def branches
      raise AuthenticationRequired unless Api.authenticated
      branches = []
      Repository.get("/repos/#{User.current.login}/#{self.name}/branches").each do |b| 
        branch = Reference.new
        branch.ref = 'ref/heads/' + b['name']
        branch.url = b['url']
        if b['commit']
          branch.object = b['commit']
          branch.object['type'] = 'commit'
        end
        branches << branch
      end
      branches
    end

    def commits(options={})
      raise AuthenticationRequired unless Api.authenticated
      commits = []
      Repository.get("/repos/#{User.current.login}/#{self.name}/commits", options).each do |c| 
        commit = Commit.new(c)
        if c['commit']
          commit.merge_attributes(c['commit'])
        end
        commits << commit
      end
      commits
    end

    def most_recent_commit(ref_sha)
      commits = self.commits(:sha => ref_sha)
      commits.first
    end
    
    def create_branch(name, parent_sha)
      Reference.create(self.name, "refs/heads/#{name}", parent_sha)
    end

    def to_s
      name
    end
    
    def pp
      
    end

  end
end
                  
