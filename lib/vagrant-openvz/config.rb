require "vagrant"

module VagrantPlugins
  module Openvz
	class Config < Vagrant.plugin("2", :config)
	  attr_accessor :physpages
	  attr_accessor :hostname
	  attr_accessor :ipadd
	  attr_accessor :nameserver
	  attr_accessor :vzctid
	  attr_accessor :pubkey
	  attr_accessor :diskspace
	  attr_accessor :diskinodes
	  attr_accessor :quotatime

	  # A String that points to a file that acts as a wrapper for sudo commands.
	  # This allows us to have a single entry when whitelisting NOPASSWD commands
	  # on /etc/sudoers
	  attr_accessor :sudo_wrapper

	  def initialize
		@customizations = []
		@sudo_wrapper   = UNSET_VALUE
	  end

	  def finalize!
		@sudo_wrapper = nil if @sudo_wrapper == UNSET_VALUE
	  end

	  def validate(machine)
		errors = []

		errors << "config.physpages" if physpages.nil?
		errors << "config.hostname" if hostname.nil?
		errors << "config.ipadd" if ipadd.nil?
		errors << "config.nameserver" if nameserver.nil?
		errors << "config.vzctid" if vzctid.nil?
		errors << "config.pubkey" if pubkey.nil?
		errors << "config.diskspace" if diskspace.nil?
		errors << "config.diskinodes" if diskinodes.nil?
		errors << "config.quotatime" if quotatime.nil?

		if @sudo_wrapper
		  hostpath = Pathname.new(@sudo_wrapper).expand_path(machine.env.root_path)
		  if ! hostpath.file?
			errors << 'vagrant_openvz.sudo_wrapper_not_found'
		  elsif ! hostpath.executable?
			errors << 'vagrant_openvz.sudo_wrapper_not_executable'
		  end
		end

		{ "openvz provider" => errors }
	  end
	end
  end
end
