# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onena/version'

Gem::Specification.new do |gem|
  gem.name          = "onena"
  gem.version       = Onena::VERSION
  gem.summary       = %q{Identify possible duplicates between Tock and Float}
  gem.description   = %q{A Ruby library and cli tool that tries to identify mismatched names between Tock and Float}
  gem.license       = "Public Domain. See LICENSE.md."
  gem.authors       = ["Christian G. Warden"]
  gem.email         = "cwarden@xerus.org"
  gem.homepage      = "https://github.com/cwarden/onena"

  gem.files         = `git ls-files`.split($/)

  `git submodule --quiet foreach --recursive pwd`.split($/).each do |submodule|
    submodule.sub!("#{Dir.pwd}/",'')

    Dir.chdir(submodule) do
      `git ls-files`.split($/).map do |subpath|
        gem.files << File.join(submodule,subpath)
      end
    end
  end
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'codeclimate-test-reporter', '~> 0.1'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rdoc', '~> 4.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'webmock'

  gem.add_runtime_dependency 'curb'
  gem.add_runtime_dependency 'text'
end
