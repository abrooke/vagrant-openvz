require "vagrant/action/builtin/confirm"

module VagrantPlugins
  module Openvz
    module Action
      class DestroyConfirm < Vagrant::Action::Builtin::Confirm
        def initialize(app, env)
          force_key = :force_confirm_destroy
          message   = "Destory Confirmation? [y/n] "
          super(app, env, message, force_key)
        end
      end
    end
  end
end
