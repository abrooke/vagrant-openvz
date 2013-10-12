module VagrantPlugins
  module Openvz
    module Action
      class Message
        def initialize(app, env, msg_key, type = :info)
          @app     = app
          @msg_key = msg_key
          @type    = type
        end

        def call(env)
          machine = env[:machine]
          message = "#{machine.name}: #{@msg_key}"

          env[:ui].send @type, message

          @app.call env
        end
      end
    end
  end
end
