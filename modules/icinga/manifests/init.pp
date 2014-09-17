class icinga {
  group { 'icinga':
    ensure => present,
    before => User['icinga'],
  }

  user { 'icinga':
    ensure => present,
    home   => '/dev/null',
    shell  => '/bin/false',
    gid    => 'icinga',
    groups => 'http',
    before => Package['icinga'],
  }

  package { ['icinga', 'nagios-plugins']:
    ensure => installed,
  }

  service { 'icinga':
    ensure => running,
    enable => true,
    require => Package['icinga']
  }
}
