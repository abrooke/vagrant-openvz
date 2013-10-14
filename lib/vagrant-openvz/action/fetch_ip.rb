module VagrantPlugins
  module Openvz
    module Action
      class FetchIp
        def initialize(app, env)
          @app = app
        end

        def call(env)
		  config = env[:machine].provider_config
         
		  if config.netadapter.nil?		  
             env[:machine_ip] ||= env[:machine].provider.driver.fetch_ip(config.vzctid)
		  else
			 env[:machine_ip] ||= env[:machine].provider.driver.fetch_ip_netadapter(config.vzctid,config.netadapter)
          end

          @app.call(env)
        end
      end
    end
  end
end
