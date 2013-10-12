module VagrantPlugins
  module Openvz
    module Action
      class ForcedHalt
        def initialize(app, env)
          @app = app
        end

        def call(env)
		  config = env[:machine].provider_config

          if env[:machine].provider.state.id == :exist_mounted_running
			env[:machine].provider.driver.forced_halt(config.vzctid)
          end

          @app.call(env)
        end
      end
    end
  end
end
