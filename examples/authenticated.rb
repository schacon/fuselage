require File.join(File.dirname(__FILE__), '..', 'lib', 'cockpit')
require 'ruby-debug'

include Cockpit

access_token = 'dd87cbeac4f189ce9395b5c6eee66dfb'

authenticated(access_token) do 
  
  puts User.current
  
end