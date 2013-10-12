Vagrant.require_plugin "vagrant-openvz"

$script = <<SCRIPT
echo I am provisioning...
date > /etc/vagrant_provisioned_at
SCRIPT
 
Vagrant.configure('2') do |config|

  config.vm.box = "centos-6-x86_64"

  config.vm.define "vz1" do |vm_vz1|
    vm_vz1.vm.provider :openvz do |openvz| 
							openvz.vzctid="1"
							openvz.physpages="0:1G"
							openvz.hostname="vz1"
							openvz.ipadd="192.168.101.1"
							openvz.nameserver="8.8.8.8"
							openvz.diskspace="1000000:1100000"
							openvz.diskinodes="100000:101000"
							openvz.quotatime="600"
							openvz.pubkey="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
		  end
		 
    vm_vz1.vm.provision "shell", inline: $script

  end


end
