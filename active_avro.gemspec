# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_avro/version"

Gem::Specification.new do |s|
  s.name        = "active_avro"
  s.version     = ActiveAvro::VERSION
  s.authors     = ['Charles Feduke']
  s.email       = ['charles.feduke@gmail.com']
  s.homepage    = "https://github.com/cfeduke/active_avro"
  s.summary     = %q{Serializes an ActiveRecord class graph hierarchy to a single type schema compatible with Apache Avro.}
  s.description = s.summary

  s.rubyforge_project = "active_avro"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activerecord'
  s.add_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sqlite3'
end
