begin
  require "vagrant"
rescue LoadError
  raise "This plugin must run within Vagrant."
end

require "vagrant-openvz/version"
require "vagrant-openvz/plugin"

