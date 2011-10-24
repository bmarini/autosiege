# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "autosiege/version"

Gem::Specification.new do |s|
  s.name        = "autosiege"
  s.version     = Autosiege::VERSION
  s.authors     = ["Ben Marini"]
  s.email       = ["bmarini@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A ruby CLI wrapper to siege}
  s.description = %q{A ruby CLI wrapper to siege}

  s.rubyforge_project = "autosiege"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "mixlib-cli", "~> 1.2.2"
end
