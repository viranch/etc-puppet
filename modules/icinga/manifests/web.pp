class icinga::web {
  include apache

  file { '/etc/httpd/conf/extra/icinga.cfg':
    ensure => link,
    target => '/etc/icinga/apache.example.conf',
    require => Package['icinga','apache'],
  }
}
