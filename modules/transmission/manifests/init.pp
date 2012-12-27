class transmission($user) {

  $home = "/home/${user}"

  package { 'transmission-cli': ensure => installed }

  $dirs = ["${home}/.config", "${home}/.config/transmission-daemon", "${home}/Downloads"]

  file { $dirs:
    ensure => directory,
    owner => $user,
    require => Package['transmission-cli'],
  }

  file { 'settings.json':
    path => "${home}/.config/transmission-daemon/settings.json",
    source => 'puppet:///modules/transmission/settings.json',
    owner => $user, mode => 600,
    require => File[$dirs],
  }

  exec { '/usr/bin/transmission-daemon':
    user => $user,
    unless => '/bin/pidof transmission-daemon',
    require => File['settings.json'],
  }

}
