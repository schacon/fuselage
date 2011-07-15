require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'
require 'ruby-debug'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'cockpit'

ENV['HOME'] = File.dirname(__FILE__)
FakeWeb.allow_net_connect = false

def stub_file(*path)
  File.join(File.dirname(__FILE__), "stubs", path)
end

def auth(&block)
  authenticated('036232258609d6188a559c34b874415e58e05a8a') do
    yield
  end
end

def fake_everything
  FakeWeb.clean_registry

  # helper variables to make things shorter.
  sha = "f6609209c3ac0badd004512d318bfaa508ea10ae"
  fake_sha = "ea3cd978650417470535f3a4725b6b5042a6ab59"

  api = "api.github.com"

  # Public stuff
  fakes = { 
    "user/coreycollins" => File.join("users", "coreycollins"),
    "user/coreycollins/repos" => File.join("repos", "show", "coreycollins"),
    "repos/coreycollins/tester" => File.join("repos", "coreycollins", "tester", "main"),
    "orgs/gitpilot/repos" => File.join("repos", "show", "gitpilot")      
  }
        
  fakes.each do |key, value|
    FakeWeb.register_uri(:get, "https://#{api}/" + key, :response => stub_file(value))
  end
  
  FakeWeb.register_uri(:get, "https://#{api}/user/i-am-most-probably-a-user-that-does-not-exist/repos", :status => ["404", "Not Found"])
  # nothere is obviously an invalid sha
  #FakeWeb.register_uri(:get, "https://#{api}/commits/show/fcoury/octopi/nothere", :status => ["404", "Not Found"])
  # not-a-number is obviously not a *number*
  #FakeWeb.register_uri(:get, "https://#{api}/issues/show/fcoury/octopi/not-a-number", :status => ["404", "Not Found"])
  # is an invalid hash
  #FakeWeb.register_uri(:get, "https://#{api}/tree/show/fcoury/octopi/#{fake_sha}", :status => ["404", "Not Found"])
  # is not a user
  FakeWeb.register_uri(:get, "https://#{api}/user/i-am-most-probably-a-user-that-does-not-exist", :status => ["404", "Not Found"])
  
  
  def auth_query
    "access_token=036232258609d6188a559c34b874415e58e05a8a"
  end
  
  secure_fakes = {
    "user?" => File.join("users", "coreycollins-private"),
    "user/emails?" => File.join("users", "emails"),
    "user/following?" => File.join("users", "following"),
    "user/followers?" => File.join("users", "followers"),
    "user/repos?type=all&" => File.join("repos", "show", "coreycollins-private"),
    "orgs/gitpilot/repos?type=all&" => File.join("repos", "show", "gitpilot-private"),
    "orgs/gitpilot/repos?type=private&" => File.join("repos", "show", "gitpilot-private"),
    "repos/coreycollins/tester?" => File.join("repos", "coreycollins", "tester", "main"),     
    "repos/coreycollins/tester/tags?" => File.join("repos", "coreycollins", "tester", "tags"),
    "repos/coreycollins/tester/branches?" => File.join("repos", "coreycollins", "tester", "branches"),
    "repos/coreycollins/tester/commits?" => File.join("repos", "coreycollins", "tester", "commits"),
    "repos/coreycollins/tester/commits/6c5b0e754460477ed049e5b1b0785e667eadaeb9?" => File.join("commits", "tester", "old"),
    "repos/coreycollins/tester/git/refs/heads/master?" => File.join("refs", "tester", "master"),
     "repos/coreycollins/tester/git/refs?" => File.join("refs", "tester", "all")                 
  }
  
  secure_fakes.each do |key, value|
    FakeWeb.register_uri(:get, "https://#{api}/" + key + auth_query, :response => stub_file(value))
  end
  
  secure_post_fakes = { 
    "user" => File.join("users", "coreycollins-patched"),
    "user/repos?name=tester&public=true&" => File.join("repos", "coreycollins", "tester", "main"),
    "repos/coreycollins/tester/commits?message=sample%20test%20commit&tree=5f2d10379330f0f76caa31d87e4bca4cefcdc3fd&parents[]=6c5b0e754460477ed049e5b1b0785e667eadaeb9&" => File.join("commits", "tester", "new")
  }
    
  secure_post_fakes.each do |key, value|
    FakeWeb.register_uri(:post, "https://#{api}/" + key + auth_query, :response => stub_file(value))
  end

end


class Test::Unit::TestCase
  
end
