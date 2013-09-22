class transmission($user) {

  $home = "/home/${user}"

  package { 'transmission-cli': ensure => installed }

  $dirs = ["${home}/.config/transmission-daemon", "${home}/.config",
    "${home}/Downloads/watch", "${home}/Downloads"]

  file { $dirs:
    ensure => directory,
    owner => $user,
    require => Package['transmission-cli'],
  }

  file { 'settings.json':
    path => "${home}/.config/transmission-daemon/settings.json",
    content => template('transmission/settings.erb'),
    owner => $user, mode => 600,
    require => File[$dirs],
  }

  file { 'tv.conf':
    path => "${home}/.tv.conf",
    source => "puppet:///modules/transmission/tv.conf",
    owner => $user, mode => 640,
  }

  cron { 'transmission-daemon':
    command => '/usr/bin/transmission-daemon',
    special => 'reboot',
    user => $user,
  }

}
