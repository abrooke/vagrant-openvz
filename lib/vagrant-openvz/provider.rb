begin
  require "vagrant"
rescue LoadError
  raise "This plugin must run within Vagrant."
end

require "log4r"

require "vagrant-openvz/action"
require "vagrant-openvz/driver"
require "vagrant-openvz/sudo_wrapper"

module VagrantPlugins
  module Openvz
	class Provider < Vagrant.plugin("2",:provider)
	  attr_reader :driver

	  def initialize(machine)
        @logger    = Log4r::Logger.new("vagrant::provider::openvz")
		@machine = machine

		ensure_openvz_installed!
		machine_id_changed
	  end

	  def sudo_wrapper
		@shell ||= begin
	      wrapper = @machine.provider_config.sudo_wrapper
	      wrapper = Pathname(wrapper).expand_path(@machine.env.root_path).to_s if wrapper
		  SudoWrapper.new(wrapper)
		end
	  end

	  def action(name)
		# Attempt to get the action method from the Action class if it
		# exists, otherwise return nil to show that we don't support the
		# given action.
		action_method = "action_#{name}"
		return Action.send(action_method) if Action.respond_to?(action_method)
		nil
	  end

	  def ensure_openvz_installed!
		unless system("which vzctl > /dev/null")
		  raise Errors::OpenvzNotInstalled
		end
	  end

	  # If the machine ID changed, then we need to rebuild our underlying
	  # container.
	  def machine_id_changed
		id = @machine.id
        @logger.debug("In Provider::machine_id_changed, id=#{id}")

		begin
          @logger.debug("Instantiating the container for: #{id.inspect}")

		  @driver = Driver.new(id, self.sudo_wrapper)
		  @driver.validate!
		rescue Driver::ContainerNotFound
		  # The container doesn't exist, so we probably have a stale
		  # ID. Just clear the id out of the machine and reload it.
		  @logger.debug("Container not found! Clearing saved machine ID and reloading.")
		  id = nil
		  retry
		end
	  end
 
	  # Returns the SSH info for accessing the Container.
      def ssh_info
        # If the Container is not created then we cannot possibly SSH into it, so
        # we return nil.
        return nil if state == :not_created

        # Run a custom action called "fetch_ip" which does what it says and puts
        # the IP found into the `:machine_ip` key in the environment.
        env = @machine.action("fetch_ip")

        # If we were not able to identify the container's IP, we return nil
        # here and we let Vagrant core deal with it ;)
        return nil unless env[:machine_ip]

        {
          :host => env[:machine_ip],
          :port => @machine.config.ssh.guest_port
        }
      end

	  def state
        @logger.debug("In Provider::state, @driver.container_name=#{@driver.container_name}")
		@logger.debug("In Provider::state, @machine.provider_config.vzctid=#{@machine.provider_config.vzctid}")

        state_id = nil

        state_id = :not_created if !@driver.container_name
        state_id = @driver.state(@machine.provider_config.vzctid) if !state_id
        state_id = :unknown if !state_id

        short = state_id.to_s.gsub("_", " ")
        long  = state_id.to_s.gsub("_", " ")

		@logger.debug("In Provider::state, state_id=#{state_id}")
        Vagrant::MachineState.new(state_id, short, long)
      end

	end
  end
end
