
module VagrantPlugins
  module  Openvz
	class VzctlVersion < Vagrant.plugin("2", "command")
	  def execute
		puts `vzctl --version`
		return 0
	  end
	end
  end
end
