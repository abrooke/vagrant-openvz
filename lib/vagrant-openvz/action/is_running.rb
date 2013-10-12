module VagrantPlugins
  module Openvz
    module Action
      class IsRunning
        def initialize(app, env)
          @app = app
        end

        def call(env)

          env[:result] = env[:machine].state.id == :exist_mounted_running

          @app.call(env)
        end
      end
    end
  end
end
