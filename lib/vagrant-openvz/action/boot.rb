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

          @app.call env
        end
      end
    end
  end
end
