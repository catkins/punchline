# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'punchline/version'

Gem::Specification.new do |spec|
  spec.name          = 'punchline'
  spec.version       = Punchline::VERSION
  spec.authors       = ['Chris Atkins']
  spec.email         = ['christopherlionelatkins@gmail.com']
  spec.summary       = %q{Persistent redis based min-priority queue}
  spec.description   = %q{Persistent redis based min-priority queue.}
  spec.homepage      = 'http://github.com/catkins/punchline'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'redis', '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'coveralls'
end
