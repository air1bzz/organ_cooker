# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'organ_cooker/version'

Gem::Specification.new do |spec|
  spec.name          = "organ-cooker"
  spec.version       = OrganCooker::VERSION
  spec.date          = '2016-05-03'
  spec.authors       = ["Erwan MORVAN"]
  spec.email         = ["air1bzz@gmail.com"]

  spec.summary       = %q{A gem for working out stuffs for organ-building.}
  spec.description   = %q{The gem 'organ-cooker' bundles everythin you need to work out datas for making an pipe organ.}
  spec.homepage      = "https://github.com/air1bzz/organ-cooker"
  spec.license       = "MIT"

=begin
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end
=end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0"

  spec.add_development_dependency 'bundler', '~> 1.12', '>= 1.12.5'
  spec.add_development_dependency 'rake',    '~> 11.2', '>= 11.2.2'
  spec.add_development_dependency 'minitest', '~> 5.9'
  spec.add_development_dependency 'pry', '~> 0.10.3'

  spec.add_runtime_dependency     'roman', '~> 0.2.0'
end
