require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib cockpit]))
require 'ruby-debug'

include Cockpit

access_token = '036232258609d6188a559c34b874415e58e05a8a'

authenticated(access_token) do 
  commit = Commit.create('tester', 'sample test commit', '5f2d10379330f0f76caa31d87e4bca4cefcdc3fd', ['6c5b0e754460477ed049e5b1b0785e667eadaeb9'])
end
