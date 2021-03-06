# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'organ_cooker/version'

Gem::Specification.new do |spec|
  spec.name          = 'organ-cooker'
  spec.version       = OrganCooker::VERSION
  spec.date          = '2016-05-03'
  spec.authors       = ['Erwan MORVAN']
  spec.email         = ['air1bzz@gmail.com']

  spec.summary       = 'A gem for working out stuffs for organ-building.'
  spec.description   = "The gem 'organ-cooker' bundles everythin you need to
                        work out datas for making a pipe organ."
  spec.homepage      = 'https://github.com/air1bzz/organ-cooker'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host', to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
    # spec.metadata["yard.run"] = "yri" # use "yard" to build full HTML docs.
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0'

  spec.add_development_dependency 'bundler',            '~> 1.13', '>= 1.13.6'
  spec.add_development_dependency 'rake',               '~> 12.0'
  spec.add_development_dependency 'minitest',           '~> 5.9'
  spec.add_development_dependency 'pry',                '~> 0.10.4'
  spec.add_development_dependency 'pry-byebug',         '~> 3.4', '>= 3.4.2'
  spec.add_development_dependency 'guard',              '~> 2.14'
  spec.add_development_dependency 'guard-minitest',     '~> 2.4',  '>= 2.4.6'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1',  '>= 1.1.11'

  spec.add_runtime_dependency     'roman',              '~> 0.2.0'
end
