# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "inkling_api/version"

Gem::Specification.new do |s|
  s.name        = "inkling_api"
  s.version     = InklingApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Chapman", "Nick Fine", "Josh Adams"]
  s.email       = ["david@isotope11.com", "nick@isotope11.com", "josh@isotope11.com"]
  s.homepage    = "http://www.isotope11.com/"
  s.summary     = %q{Gem to interact with inkling markets API}

  s.rubyforge_project = "inkling_api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('faraday', '~> 0.7.4')
  s.add_dependency('faraday-stack', '~> 0.1.3')
  s.add_dependency('hashie', '~> 1.1.0')
  s.add_dependency('activesupport', '~> 3.0.9')
  s.add_dependency('i18n', '~> 0.6.0')
  s.add_dependency('builder', '~> 3.0.0')

  s.add_development_dependency('rspec', '~> 2.6.0')
  s.add_development_dependency('rspec-core', '~> 2.6.0')
  s.add_development_dependency('json_spec', '~> 0.6.0')
  s.add_development_dependency('shoulda', '~> 2.11.3')
  s.add_development_dependency('ruby-debug19')
end
