# Install elasticsearch

class elasticsearch::install {

	package { [
	  'openjdk-7-jre-headless',
	  'wget'
	]:
	ensure => present,
	}

  exec { 'download elasticsearch':
    command => 'wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.deb && dpkg -i elasticsearch-1.5.0.deb',
    require => Package['wget'],
  }

  exec { 'download elasticsearch servicewrapper':
    command => 'curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz',
    require => Package['curl'],
  }

  file { "/usr/local/share/elasticsearch":
    ensure => "directory",
  }

  file { "/usr/local/share/elasticsearch/bin":
    ensure => "directory",
  }

  exec { 'move service to bin':
    command => 'mv *servicewrapper*/service /usr/local/share/elasticsearch/bin/',
    require => Package['curl'],
  }

  exec { 'remove tmp directory':
    command => 'rm -Rf *servicewrapper*',
    require => Package['curl'],
  }

  exec { 'install elasticsearch':
    command => '/usr/local/share/elasticsearch/bin/service/elasticsearch install',
    require => Package['curl'],
  }

  file { '/usr/local/bin/rcelasticsearch':
    ensure  => link,
    target  => '/usr/local/share/elasticsearch/bin/service/elasticsearch',
  }

  service { "elasticsearch":
    ensure => "running",
  }
}
