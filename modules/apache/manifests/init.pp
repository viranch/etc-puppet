class apache {

  package { 'apache': ensure => installed }

  file { '/etc/httpd/conf/httpd.conf':
    content => template('apache/httpd_conf.erb'),
    owner => root, group => root, mode => 644,
    require => Package['apache'],
  }

  file { '/srv/http':
    ensure => directory,
  }

}
