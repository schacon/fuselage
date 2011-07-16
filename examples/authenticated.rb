require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib cockpit]))
require 'ruby-debug'

include Cockpit

access_token = '11d5295ea3814f9be2e52d966252cc461dab200b'

authenticated(access_token) do 
  repo = Repository.find('tester')
  master_ref = Reference.find(repo.name,'heads/master')
  branch = repo.create_branch('jpisgay', master_ref.sha)
  puts branch
end
