module VagrantPlugins
  module Openvz 
    module Action
      class Created
        def initialize(app, env)
          @app = app
        end

        def call(env)

          # Set the result to be true if the machine is created.
	      env[:result] = true 
		  env[:result] = false if env[:machine].state.id == :not_created

          @app.call(env)
        end
      end
    end
  end
end
