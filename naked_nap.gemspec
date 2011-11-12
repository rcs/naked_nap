# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "naked_nap/version"

Gem::Specification.new do |s|
  s.name        = "naked_nap"
  s.version     = NakedNap::VERSION
  s.authors     = ["Ryan Sorensen"]
  s.email       = ["rcsorensen@gmail.com"]
  s.homepage    = "http://github.com/rcs/naked_nap"
  s.summary     = %q{Turn a Ruby class into a RESTful Rack application}
  s.description = %q{NakedNap wraps a Ruby class for Rack use, translating HTTP semantics to Ruby method calls.}

  s.rubyforge_project = "naked_nap"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.7.1' # For Ruby 1.9.3
  s.add_development_dependency 'cucumber', '>= 0'
  s.add_development_dependency 'bundler', '~> 1.0.0'

  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'

  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rack-test'

  s.add_development_dependency 'growl'

  s.add_dependency 'rack'
  s.add_dependency 'multi_json'
end
