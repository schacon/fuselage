module Cockpit
  class Repository < Base

    attr_accessor :description, :url, :forks, :name, :homepage, :watchers, 
                  :owner, :private, :fork, :open_issues, :pledgie, :size

    # Finds all public repos identified by the given username
    #
    def self.find_by_username(username)
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

    def to_s
      name
    end

  end
end
                  
