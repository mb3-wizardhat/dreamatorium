# Install ohmyzsh

class ohmyzsh::install {
  exec { 'install ohmyzsh':
    command => 'sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"',
    require => Package['curl'],
    user => 'vagrant',
    environment => ['HOME=/home/vagrant'],
  }
}
