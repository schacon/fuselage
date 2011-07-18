require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib cockpit]))

include Cockpit

user = User.find 'coreycollins'
puts user
