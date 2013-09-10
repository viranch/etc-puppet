class apache {

  package { 'apache': ensure => installed }

  service { 'httpd':
    enable => true,
    require => File['/etc/httpd/conf/httpd.conf'],
  }

  file { '/etc/httpd/conf/httpd.conf':
    content => template('apache/httpd_conf.erb'),
    owner => root, group => root, mode => 644,
    require => Package['apache'],
  }

  file { '/srv/http':
    ensure => directory,
  }

}
