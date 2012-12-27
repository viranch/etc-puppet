class apache {

  package { 'apache': ensure => installed }

  file { '/etc/httpd/conf/httpd.conf':
    source => 'puppet:///modules/apache/httpd.conf',
    owner => root, group => root, mode => 644,
    require => Package['apache'],
  }

  file { '/srv/http':
    ensure => directory,
  }

}
