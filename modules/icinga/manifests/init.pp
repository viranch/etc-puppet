class icinga {
  package { ['icinga', 'nagios-plugins']:
    ensure => installed,
  }

  service { 'icinga':
    ensure => running,
    enable => true,
    require => Package['icinga']
  }

  File {
    notify => Service['icinga']
  }
}
