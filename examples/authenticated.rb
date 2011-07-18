require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib cockpit]))

include Cockpit

access_token = "YOUR ACCESS TOKEN"

#Creating a branch on a private repo

authenticated(access_token) do 

  #Find the repo.
  repo = Repository.find('private-repo')
  
  # Get the most recent commit to point the reference to.
  recent_commit = repo.most_recent_commit
  
  #Create the reference
  ref = Reference.create(repo.name, 'new-branch', recent_commit.sha)
  
  puts ref
end
