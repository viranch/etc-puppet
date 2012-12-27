class transmission($user) {

  $home = "/home/${user}"

  package { 'transmission-cli': ensure => installed }

  file { 'config-dir':
    path => "${home}/.config/transmission-daemon",
    ensure => directory,
    recurse => true,
    require => Package['transmission-cli'],
  }

  file { ["${home}/.config", "${home}/.config/transmission-daemon"]:
    ensure => directory,
    owner => $user,
    require => File['config-dir'],
  }

  file { 'settings.json':
    path => "${home}/.config/transmission-daemon/settings.json",
    source => 'puppet:///modules/transmission/settings.json',
    owner => $user, mode => 644,
    require => File['config-dir'],
  }

  file { 'downloads':
    path => "${home}/Downloads",
    ensure => directory,
    owner => $user,
  }

  exec { '/usr/bin/transmission-daemon':
    user => $user,
    unless => '/bin/pidof transmission-daemon',
    require => File['settings.json', 'downloads'],
  }

}
