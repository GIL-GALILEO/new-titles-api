Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/bionic64'
  config.vm.network :forwarded_port, guest: 5432, host: 9432
  config.vm.provision 'shell', inline: <<-SHELL
    sudo date > /etc/vagrant_provisioned_at
    apt-get update
    apt-get upgrade -y
    apt-get -y -q install libicu60
  SHELL
  config.vm.provision :shell, path: 'provision/postgres.sh'
end