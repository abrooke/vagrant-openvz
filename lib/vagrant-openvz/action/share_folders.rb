module VagrantPlugins
  module Openvz
	module Action
	  class ShareFolders
		def initialize(app, env)
		  @app = app
		end

		def call(env)
		  @env = env
		  prepare_folders
		  @app.call env
		  add_folders
		end

		def shared_folders
		  {}.tap do |result|
			@env[:machine].config.vm.synced_folders.each do |id, data|
			  # This to prevent overwriting the actual shared folders data
			  result[id] = data.dup
			end
		  end
		end

		# Prepares the shared folders by verifying they exist and creating them
		# if they don't.
		def prepare_folders
		  shared_folders.each do |id, options|
			hostpath = Pathname.new(options[:hostpath]).expand_path(@env[:root_path])
			if !hostpath.directory? && options[:create]
			  # Host path doesn't exist, so let's create it.
			  begin
				hostpath.mkpath
			  rescue Errno::EACCES
				raise Vagrant::Errors::SharedFolderCreateFailed,
				  :path => hostpath.to_s
			  end
			end
		  end
		end

		def add_folders
		  folders = []
		  shared_folders.each do |id, data|
			folders << {
			  :name      => id,
			  :hostpath  => File.expand_path(data[:hostpath], @env[:root_path]),
			  :guestpath => data[:guestpath]
			}
		  end
		  @env[:machine].provider.driver.share_folders(folders,@env[:machine].provider_config.vzctid)
		end
	  end
	end
  end
end
