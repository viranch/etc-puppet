class transmission {

  package { 'transmission-cli': ensure => installed }

  file { 'config-dir':
    path => '/var/lib/transmission/.config/transmission-daemon',
    ensure => directory,
    recurse => true,
    require => Package['transmission-cli'],
  }

  file { 'ensure-owner':
    path => '/var/lib/transmission/.config',
    ensure => directory,
    owner => transmission, group => transmission,
    require => File['config-dir'],
  }

  file { 'settings.json':
    path => "/var/lib/transmission/.config/transmission-daemon/settings.json",
    source => 'puppet:///transmission/settings.json',
    require => File['ensure-owner'],
  }

  exec { "/usr/bin/transmission-daemon":
    require => File['settings.json'],
  }
}
