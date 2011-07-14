require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'cockpit'

ENV['HOME'] = File.dirname(__FILE__)
FakeWeb.allow_net_connect = false

def stub_file(*path)
  File.join(File.dirname(__FILE__), "stubs", path)
end

def fake_everything
  FakeWeb.clean_registry

  # helper variables to make things shorter.
  sha = "f6609209c3ac0badd004512d318bfaa508ea10ae"
  fake_sha = "ea3cd978650417470535f3a4725b6b5042a6ab59"

  api = "api.github.com"
  
  # Public stuff
  fakes = { 
    "user/coreycollins" => File.join("users", "coreycollins")       
  }
        
  fakes.each do |key, value|
    FakeWeb.register_uri(:get, "https://#{api}/" + key, :response => stub_file(value))
  end
  
  FakeWeb.register_uri(:get, "https://#{api}/repos/coreycollins/doesnt-exsist", :response => stub_file("errors", "repository", "not_found"))
  
  # nothere is obviously an invalid sha
  #FakeWeb.register_uri(:get, "https://#{api}/commits/show/fcoury/octopi/nothere", :status => ["404", "Not Found"])
  # not-a-number is obviously not a *number*
  #FakeWeb.register_uri(:get, "https://#{api}/issues/show/fcoury/octopi/not-a-number", :status => ["404", "Not Found"])
  # is an invalid hash
  #FakeWeb.register_uri(:get, "https://#{api}/tree/show/fcoury/octopi/#{fake_sha}", :status => ["404", "Not Found"])
  # is not a user
  FakeWeb.register_uri(:get, "https://#{api}/user/i-am-most-probably-a-user-that-does-not-exist", :status => ["404", "Not Found"])
  
  
  def auth_query
    "?access_token=036232258609d6188a559c34b874415e58e05a8a"
  end
  
  secure_fakes = {
    "user" => File.join("users", "coreycollins-private")
  }
  
  secure_fakes.each do |key, value|
    FakeWeb.register_uri(:get, "https://#{api}/" + key + auth_query, :response => stub_file(value))
  end
  
  secure_post_fakes = { 
    "user" => File.join("users", "coreycollins-patched")
  }
    
  secure_post_fakes.each do |key, value|
    FakeWeb.register_uri(:post, "https://#{api}/" + key + auth_query, :response => stub_file(value))
  end

end


class Test::Unit::TestCase
  
end
