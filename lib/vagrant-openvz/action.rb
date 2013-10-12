require 'vagrant-openvz/action/boot'
require 'vagrant-openvz/action/created'
require 'vagrant-openvz/action/create'
require 'vagrant-openvz/action/is_running.rb'
require 'vagrant-openvz/action/destroy'
require 'vagrant-openvz/action/destroy_confirm.rb'
require 'vagrant-openvz/action/forced_halt.rb'
require 'vagrant-openvz/action/message.rb'
require 'vagrant-openvz/action/fetch_ip.rb'
require 'vagrant-openvz/action/check_running.rb'
require 'vagrant-openvz/action/check_created.rb'
require 'vagrant-openvz/action/share_folders.rb'

require "log4r"

begin
  require "vagrant/action/builder"
rescue LoadError
  raise "This plugin must run within Vagrant."
end

module VagrantPlugins
  module Openvz
	module Action
	  
	  # This action brings the machine up from nothing, including creating the
	  # container, and booting.
	  def self.action_up
		Vagrant::Action::Builder.new.tap do |bldr|
		  bldr.use Vagrant::Action::Builtin::ConfigValidate
		  bldr.use Vagrant::Action::Builtin::Call, Created do |env, intern_bldr|
			# If the VM is NOT created yet, then do the setup steps
			if !env[:result]
			  intern_bldr.use Vagrant::Action::Builtin::HandleBoxUrl
			  intern_bldr.use Create
			end
		  end
		  bldr.use action_start
		end
	  end

	  # This action starts a container, assuming it is already created and exists.
	  # A precondition of this action is that the container exists.
	  def self.action_start
		Vagrant::Action::Builder.new.tap do |bldr|
		  bldr.use Vagrant::Action::Builtin::ConfigValidate
		  bldr.use Vagrant::Action::Builtin::Call, IsRunning do |env, intern_bldr|
			# If the VM is running, then our work here is done, exit
			next if env[:result]
			intern_bldr.use action_boot
		  end
		end
	  end

	  # This action boots the VM, assuming the VM is in a state that requires
	  # a bootup (i.e. not saved).
	  def self.action_boot
		Vagrant::Action::Builder.new.tap do |bldr|
		  bldr.use Vagrant::Action::Builtin::Provision
		  bldr.use Vagrant::Action::Builtin::EnvSet, :port_collision_repair => true
		  bldr.use Vagrant::Action::Builtin::HandleForwardedPortCollisions
		  bldr.use ShareFolders
		  bldr.use Vagrant::Action::Builtin::SetHostname
		  #TODO: Port forwarding.
		  bldr.use Boot
		  bldr.use Vagrant::Action::Builtin::WaitForCommunicator
		end
	  end

	  # This is the action that is primarily responsible for halting
	  # the virtual machine, gracefully or by force.
	  def self.action_halt
        logger = Log4r::Logger.new("vagrant::provider::openvz")
		Vagrant::Action::Builder.new.tap do |bldr|
		  bldr.use Vagrant::Action::Builtin::Call, Created do |env, intern_bldr|
            logger.debug("In Action::action_halt, env[:result]=#{env[:result]}") 
			if env[:result]
			  #TODO: Clear forwarded ports.
			  #TODO: Remove Temporary Files
			  #TODO: Graceful halt
			  intern_bldr.use ForcedHalt
			else
			  intern_bldr.use Message, :not_created
			end
		  end
		end
	  end

	  # This is the action that is primarily responsible for completely
	  # freeing the resources of the underlying virtual machine.
	  def self.action_destroy
		Vagrant::Action::Builder.new.tap do |bldr|
		  bldr.use Vagrant::Action::Builtin::Call, Created do |env1, intern_bldr|
			if !env1[:result]
			  intern_bldr.use Message, :not_created
			  next
			end

			intern_bldr.use Vagrant::Action::Builtin::Call, DestroyConfirm do |env2, intern2_bldr|
			  if env2[:result]
				intern2_bldr.use Vagrant::Action::Builtin::ConfigValidate
				intern2_bldr.use Vagrant::Action::Builtin::EnvSet, :force_halt => true
				intern2_bldr.use action_halt
				intern2_bldr.use Destroy
				#TODO: Use Vagrant::Action::Builtin::ProvisionerCleanup (vagrant 1.3+)
			  else
			    intern2_bldr.use Message, :will_not_destroy
			  end
			end
		  end
		end
	  end

	  # This action is called to read the IP of the container. The IP found
      # is expected to be put into the `:machine_ip` key.
      def self.action_fetch_ip
        Vagrant::Action::Builder.new.tap do |bldr|
          bldr.use Vagrant::Action::Builtin::ConfigValidate
          bldr.use FetchIp
        end
      end
 
	  # This is the action that will exec into an SSH shell.
      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |bldr|
          bldr.use CheckCreated
          bldr.use CheckRunning
          bldr.use Vagrant::Action::Builtin::SSHExec
        end
      end

	  # This is the action that will run a single SSH command.
      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |bldr|
          bldr.use CheckCreated
          bldr.use CheckRunning
          bldr.use Vagrant::Action::Builtin::SSHRun
        end
      end

	  # This action just runs the provisioners on the machine.
      def self.action_provision
        Vagrant::Action::Builder.new.tap do |bldr|
          bldr.use Vagrant::Action::Builtin::ConfigValidate
          bldr.use Vagrant::Action::Builtin::Call, Created do |env1, intern_bldr|
            if !env1[:result]
              intern_bldr.use Message, :not_created
              next
            end

            b2.use Vagrant::Action::Builtin::Call, IsRunning do |env2, intern2_bldr|
              if !env2[:result]
                intern2_bldr.use Message, :not_running
                next
              end

              intern2_bldr.use Vagrant::Action::Builtin::Provision
            end
          end
        end
      end

	end
  end
end
