# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stateful_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "stateful_enum"
  spec.version       = StatefulEnum::VERSION
  spec.authors       = ["Akira Matsuda"]
  spec.email         = ["ronnie@dio.jp"]

  spec.summary       = 'A state machine plugin on top of ActiveRecord::Enum'
  spec.description   = 'A state machine plugin on top of ActiveRecord::Enum'
  spec.homepage      = 'https://github.com/amatsuda/stateful_enum'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'ruby-graphviz'
end
