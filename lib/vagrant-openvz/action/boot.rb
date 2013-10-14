module VagrantPlugins
  module Openvz
	module Action
	  class Boot
		def initialize(app, env)
		  @app = app
		end

		def call(env)
		  @env = env

		  config = env[:machine].provider_config

		  env[:machine].provider.driver.start(config.vzctid,config.pubkey)

		  if ! config.netadapter.nil?
			env[:machine].provider.driver.set_netadapter(
			  config.vzctid,config.netadapter
			)
		  end

		  @app.call env
		end
	  end
	end
  end
end
