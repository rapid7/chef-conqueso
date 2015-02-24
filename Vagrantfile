# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.hostname = 'conqueso-chef-berkshelf'
  config.vm.box = 'ubuntu-14.04-provisionerless'
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/'\
    'current/trusty-server-cloudimg-amd64-vagrant-disk1.box'

  config.vm.network :forwarded_port, guest: 8080, host: 8080

  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = './Berksfile'

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :mysql => {
        :server_root_password => 'root',
        :server_debian_password => 'debpass',
        :server_repl_password => 'replpass'
      },
      :conqueso => {
        :install_method => :source,
        # :start => false,
        # :install => {
          # :mysqlserver => false,
          # :mysqlclient => false
        # }
      }
    }

    chef.run_list = [
      'recipe[conqueso::default]'
    ]
  end
end
