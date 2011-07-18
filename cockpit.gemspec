# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cockpit/version"

Gem::Specification.new do |s|
  s.name        = "cockpit"
  s.version     = Cockpit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Corey Collins"]
  s.email       = ["corey@gitpilot.com"]
  s.homepage    = ""
  s.summary     = %q{LightWeight Github API v3 Wrapper}
  s.description = %q{LightWeight Github API v3 Wrapper}

  s.rubyforge_project = "cockpit"
  
  s.add_development_dependency "rspec"
  s.add_development_dependency "fakeweb"
  s.add_dependency "httparty"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
