module VagrantPlugins
  module Openvz
    module Action
      class Create
        def initialize(app, env)
          @app = app
        end

        def call(env)
		  config = env[:machine].provider_config
          box = env[:machine].box

          container_name = "vz#{config.vzctid}"
        
		  settings={}
		  settings.merge!(:physpages => config.physpages)
          settings.merge!(:hostname => container_name)
		  settings.merge!(:ipadd => config.ipadd)
          settings.merge!(:nameserver => config.nameserver)
		  settings.merge!(:diskspace => config.diskspace)
		  settings.merge!(:diskinodes => config.diskinodes)
		  settings.merge!(:quotatime => config.quotatime)
          settings.merge!(:template_name => "#{box.name}")

          env[:machine].provider.driver.create(
            container_name,config.vzctid,settings
          )

          env[:machine].id = container_name

          @app.call env
        end
      end
    end
  end
end
