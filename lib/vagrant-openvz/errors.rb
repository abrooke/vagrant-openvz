require 'vagrant/errors'

module VagrantPlugins
  module Openvz 
    module Errors

      class ExecuteError < Vagrant::Errors::VagrantError
        error_key(:openvz_execute_error)
      end

      class OpenvzNotInstalled < Vagrant::Errors::VagrantError
        error_key(:openvz_not_installed)
      end

      # Box related errors
      class TemplateFileMissing < Vagrant::Errors::VagrantError
        error_key(:openvz_template_file_missing)
      end

      class RootFSTarballMissing < Vagrant::Errors::VagrantError
        error_key(:openvz_invalid_box_version)
      end

      class IncompatibleBox < Vagrant::Errors::VagrantError
        error_key(:openvz_incompatible_box)
      end
    end
  end
end
