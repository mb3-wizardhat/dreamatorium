# Install nginx

class nginx::install {

  File {
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  package { 'nginx':
    ensure => present,
  }->

  service { 'nginx':
    ensure  => running,
    enable  => "true",
  }

  # the httpd.conf change the user/group that apache uses to run its process
  file { '/etc/nginx/sites-available/apache.conf':
    source  => '/vagrant/files/etc/nginx/apache.conf',
    notify  => Service["nginx"],
    mode    => 600,
    owner   => "root",
    group   => "root",
    require => Package["nginx"],
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure  => link,
    target  => '/etc/nginx/sites-available/apache.conf',
  }

}
