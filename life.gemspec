# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'life/version'

Gem::Specification.new do |spec|
  spec.name          = "game-of-life"
  spec.version       = Life::VERSION
  spec.authors       = ["Jason Knabl"]
  spec.email         = ["jason.knabl@gmail.com"]

  spec.summary       = %q{A simple cellular automaton based on Conway's original.}
  spec.description   = %q{A simple cellular automaton based on Conway's original..}
  spec.homepage      = "https://www.github.com/jknabl/life"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "no"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  # spec.executables << 'test'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", '~> 0.11.1'
  spec.add_dependency "OptionParser"
end
