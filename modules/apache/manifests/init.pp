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

  $users = hiera('users', [], 'users')
  httpd_symlink { $users: }

  define httpd_symlink() {
    $user = $name
    file { "/srv/http/${user}":
      ensure => link,
      target => "/home/${user}/Downloads",
      require => User[$user],
    }
  }

}
