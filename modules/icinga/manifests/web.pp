class icinga::web {
  include apache

  $mod_cgi = ['mod_fastcgi', 'mod_fcgid']
  package { $mod_cgi: ensure => installed }

  file { '/etc/httpd/conf/extra/icinga.conf':
    ensure => link,
    target => '/etc/icinga/apache.example.conf',
    require => Package['icinga', 'apache', $mod_cgi],
  }
}
