require File.join(File.dirname(__FILE__), '..', 'lib', 'cockpit')
require 'ruby-debug'

include Cockpit

access_token = '036232258609d6188a559c34b874415e58e05a8a'

authenticated(access_token) do 
  
  puts User.current
  
end
