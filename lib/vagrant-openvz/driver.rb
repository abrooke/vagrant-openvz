require "vagrant-openvz/errors"
require "vagrant-openvz/driver/cli"
require "etc"

require "log4r"


module VagrantPlugins
  module Openvz
	class Driver
	  
	  # This is raised if the container can't be found when initializing it with
	  # a name.
	  class ContainerNotFound < StandardError; end

	  # Root folder where container configs are stored
	  CONTAINERS_PATH = '/vz/root/' 

	  attr_reader :container_name, :customizations

	  def generate_guest_path(path,vzctlid)
        Pathname.new("#{CONTAINERS_PATH}#{vzctlid}").join(path.gsub(/^\//, ''))
	  end

	  def initialize(container_name, sudo_wrapper, cli = nil)
        @logger    = Log4r::Logger.new("vagrant::provider::openvz")
		@container_name = container_name
        @logger.debug("In Driver::initialize, @container_name=#{@container_name}")
		@sudo_wrapper   = sudo_wrapper
		@cli            = cli || CLI.new(sudo_wrapper, container_name)
		# @logger         = Log4r::Logger.new("vagrant::provider::lxc::driver")
		@customizations = []
	  end

	  def share_folders(folders,vzctlid)
        folders.each do |folder|
          guestpath = generate_guest_path(folder[:guestpath],vzctlid) 
          @logger.debug("In Driver::share_folders, guestpath=#{guestpath}")
          @logger.debug("In Driver::create, guestpath.directory?=#{guestpath.directory?}")
		  unless guestpath.directory?
            begin
              @logger.debug("Guest path doesn't exist, creating: #{guestpath}")
              @sudo_wrapper.run("mkdir", '-p', guestpath.to_s)
            rescue Errno::EACCES
              raise Vagrant::Errors::SharedFolderCreateFailed, :path => guestpath.to_s
            end
          end
          @cli.share_folder(folder[:hostpath],guestpath)
        end
      end

	  def validate!
		raise ContainerNotFound if @container_name && ! @cli.list.include?(@container_name)
	  end

	  def create(name,vzctlid,settings={})
        @logger.debug("In Driver::create, parameter name=#{name}")
		@cli.name = @container_name = name
		@logger.debug("In Driver::create, @container_name=#{@container_name}")

		@cli.create vzctlid, settings 
	  end

	  def set_netadapter(vzctlid,netadapter)
		@logger.info("Adding network adapter: #{netadapter}")
		@cli.set_netadapter(vzctlid,netadapter)
	  end
	
	  def start(vzctlid,pubkey)
		@logger.info('Starting container...')
		@cli.start(vzctlid,pubkey)
	  end
	  
      def forced_halt(vzctlid)
        @logger.info('Shutting down container...')
		@cli.stop(vzctlid)
	  end

	  def destroy(vzctlid)
        @cli.destroy(vzctlid)
      end
    
	  def state(vzctlid)
        if @container_name
           @cli.status(vzctlid)
        end
      end

	  def fetch_ip(vzctlid)
		@cli.fetch_ip(vzctlid)
	  end

	  def fetch_ip_netadapter(vzctlid,netadapter)
		@cli.fetch_ip_netadapter(vzctlid,netadapter)
	  end

	end
  end
end
