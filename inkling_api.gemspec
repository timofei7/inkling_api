# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "inkling_api/version"

Gem::Specification.new do |s|
  s.name        = "inkling_api"
  s.version     = InklingApi::VERSION
  s.authors     = ["David Chapman", "Nick Fine", "Josh Adams", "Tim Tregubov"]
  s.email       = ["david@isotope11.com", "nick@isotope11.com", "josh@isotope11.com", "tim@zingweb.com"]
  s.homepage    = "http://www.isotope11.com/"
  s.summary     = %q{Gem to interact with inkling markets API}
  s.description = %q{Gem to interact with inkling markets API}

  s.rubyforge_project = "inkling_api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('faraday')
  s.add_dependency('faraday-stack')
  s.add_dependency('hashie')
  s.add_dependency('activesupport')
  s.add_dependency('i18n')
  s.add_dependency('builder')

  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-core')
  s.add_development_dependency('json_spec')
  s.add_development_dependency('shoulda')
end
