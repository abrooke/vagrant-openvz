require "vagrant"

module VagrantPlugins
  module Openvz
	class Plugin < Vagrant.plugin("2")

	  name "vagrant-openvz"

	  description <<-DESC
	  This plugin installs a provider that allows vagrant to manage
	  Openvz machine instances.
	  DESC
	  
	  config(:openvz, :provider) do
		require_relative 'config'
		Config
	  end

	  command "vzctl-version" do
		require_relative "command/version"
		VzctlVersion	
	  end

	  provider(:openvz) do
		require_relative "provider"
		Provider
	  end

	end
  end
end

