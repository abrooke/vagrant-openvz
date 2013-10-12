module VagrantPlugins
  module Openvz
    module Action
      class Destroy
        def initialize(app, env)
          @app = app
        end

        def call(env)
          config = env[:machine].provider_config

          env[:ui].info "Destroying!" 
          env[:machine].provider.driver.destroy(config.vzctid)

          env[:machine].id = nil
          @app.call env
        end
      end
    end
  end
end
