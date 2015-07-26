# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

cfg = YAML::load_file('config.yml')
cfg['nodes'].each do |node|
    node.merge!(cfg['default']) { |key, nval, tval | nval }
    node['box_url'] = cfg['boxes'][node['box']]
    node['fqdn'] = node['name'] + '.' + node['domain']
end

######################


Vagrant.configure("2") do |config|

    cfg['nodes'].each do |node|
        config.vm.define node['name'] do |node_config|
            node_config.vm.hostname = node['name']
            node_config.vm.box = node['box']
            node_config.vm.synced_folder node['share_dir'], node['share_path']
            node_config.vm.box_url = node['box_url']
            node_config.vm.network :private_network, ip: node['ip']

            node_config.vm.provider :virtualbox do |vb|
                if  node['cpus'].to_i > 1
                    vb.customize ["modifyvm", :id, "--ioapic", "on"]
                end
                vb.customize ["modifyvm", :id, "--cpus", node['cpus']]
                vb.customize ["modifyvm", :id, "--memory", node['memory']]
                vb.customize ["modifyvm", :id, "--name", node['name']]
                vb.gui = node['gui']
            end

            node_config.vm.provision "shell" do |s|
                s.inline = "apt-get $1"
                s.args   = ["update"]
                s.inline = "apt-get upgrade"
            end

           node_config.vm.provision :puppet do |puppet|
                puppet.manifests_path = "manifests"
                puppet.module_path = "modules"
                lang = node['lang']
                case lang
                when "golang"
                    puppet.manifest_file  = "golang.pp"
                when "nodejs"
                    puppet.manifest_file  = "nodejs.pp"
                when "ruby"
                    puppet.manifest_file  = "ruby.pp"
                when "python"
                    puppet.manifest_file  = "python.pp"
                when "lamp"
                    puppet.manifest_file  = "lamp.pp"
                when "custom"
                    puppet.manifest_file  = node['manifest']
                else
                    puppet.manifest_file  = "init.pp"
                end
           end

        end
    end
end


####################

Vagrant.configure("2") do |config|
  config.vm.box = "trusty64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  # allows running commands globally in shell for installed composer libraries
  config.vm.provision :shell, path: "files/scripts/setup.sh"

  # setup virtual hostname and provision local IP
  config.vm.hostname = "moonbase.dev"
  config.vm.network :private_network, :ip => "192.168.50.4"
  config.hostsupdater.aliases = %w{www.moonbase.dev}
  config.hostsupdater.aliases = %w{moonbase.dev}
  config.hostsupdater.remove_on_suspend = true

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "init.pp"
    puppet.options="--verbose --debug"
  end

  # Fix for slow external network connections
  config.vm.provider :virtualbox do |vb|
    vb.memory = 1024
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
  end
end
