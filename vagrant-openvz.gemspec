# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-openvz/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-openvz"
  spec.version       = VagrantPlugins::Openvz::VERSION
  spec.authors       = ["Aslan Brooke"]
  spec.email         = ["aslandbrooke@yahoo.com"]
  spec.description   = %q{Vagrant plugin for using OpenVZ as a provider.}
  spec.summary       = %q{Vagrant plugin for using OpenVZ as a provider.}
  spec.homepage      = "https://github.com/abrooke/vagrant-openvz"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
