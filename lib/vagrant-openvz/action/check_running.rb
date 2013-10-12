module VagrantPlugins
  module Openvz
    module Action
      class CheckRunning
        def initialize(app, env)
          @app = app
        end

        def call(env)
          if env[:machine].state.id != :exist_mounted_running
            raise Vagrant::Errors::VMNotRunningError
          end

          @app.call(env)
        end
      end
    end
  end
end
