module VagrantPlugins
  module Openvz
    module Action
      class FetchIp
        def initialize(app, env)
          @app = app
        end

        def call(env)
		  config = env[:machine].provider_config

          env[:machine_ip] ||= env[:machine].provider.driver.fetch_ip(config.vzctid)

          @app.call(env)
        end
      end
    end
  end
end
