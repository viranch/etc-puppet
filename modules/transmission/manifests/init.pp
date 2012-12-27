class transmission($user) {

  $home = "/home/${user}"

  package { 'transmission-cli': ensure => installed }

  $dirs = ["${home}/.config", "${home}/.config/transmission-daemon", "${home}/Downloads"]

  file { $config_dirs:
    ensure => directory,
    owner => $user,
    require => Package['transmission-cli'],
  }

  file { 'settings.json':
    path => "${home}/.config/transmission-daemon/settings.json",
    source => 'puppet:///modules/transmission/settings.json',
    owner => $user, mode => 644,
    require => File[$config_dirs],
  }

  exec { '/usr/bin/transmission-daemon':
    user => $user,
    unless => '/bin/pidof transmission-daemon',
    require => File['settings.json'],
  }

}
