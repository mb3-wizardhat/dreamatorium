# Install wp-cli

class wpcli::install {

exec { 'install wpcli':
  command => 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp',
  require => Package['curl'],
}

}
