require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib cockpit]))
require 'ruby-debug'

include Cockpit

access_token = '11d5295ea3814f9be2e52d966252cc461dab200b'

authenticated(access_token) do 
  repo = Repository.find('tester')

  master_branch = Reference.find(repo.name,'heads/master')
  ma_recent_commit = repo.most_recent_commit(master_branch.sha)

  jpisgay_branch = Reference.find(repo.name,'heads/conflict')
  jp_recent_commit = repo.most_recent_commit(jpisgay_branch.sha)

  new_commit = Commit.create(repo.name, "Merged Conflict", jp_recent_commit.tree['sha'], parents = [ma_recent_commit.sha, jp_recent_commit.sha])
  updated_master_branch = Reference.update(repo.name, 'heads/master', new_commit.sha)
end
