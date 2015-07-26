# Install nvm

class nvm::install {
  exec { 'install nvm':
    command => 'curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash',
    require => Package['curl'],
    user => 'vagrant',
    environment => ['HOME=/home/vagrant'],
  }
}
