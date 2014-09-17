class icinga {
  group { 'icinga':
    ensure => present,
    before => User['icinga'],
  }

  user { 'icinga':
    ensure     => present,
    home       => '/var/spool/icinga',
    managehome => true,
    shell      => '/bin/false',
    gid        => 'icinga',
    groups     => 'http',
    before     => Package['icinga'],
  }

  package { ['icinga', 'monitoring-plugins']:
    ensure => installed,
  }

  service { 'icinga':
    ensure => running,
    enable => true,
    require => Package['icinga']
  }
}
