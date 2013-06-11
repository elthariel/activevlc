# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activevlc/version'

Gem::Specification.new do |spec|
  spec.name          = "activevlc"
  spec.version       = Activevlc::VERSION
  spec.authors       = ["Julien 'Lta' BALLET"]
  spec.email         = ["contact@lta.io"]
  spec.summary       = %q{DSL for building VLC pipelines}
  spec.description   = %q{ActiveVlc provides a convenient DSL to build VLC transcoding and/or streaming pipelines}
  spec.homepage      = "github.com/elthariel/activevlc"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
