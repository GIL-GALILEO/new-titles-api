Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.network :forwarded_port, guest: 5432, host: 9432
  config.vm.provision :shell, path: 'provision/postgres.sh'
end