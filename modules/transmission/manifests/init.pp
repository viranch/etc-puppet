class transmission($user) {

  $home = "/home/${user}"

  package { 'transmission-cli': ensure => installed }

  $config_dir = "${home}/.config/transmission-daemon"
  $watch_dir = "/tmp/watch"
  $dirs = [$config_dir, "${home}/.config",
    $watch_dir, "${home}/Downloads"]

  file { $dirs:
    ensure => directory,
    owner => $user,
    require => Package['transmission-cli'],
  }

  file { 'settings.json':
    path => "${config_dir}/settings.json",
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

  cron { 'tv':
    command => "${home}/playground/scripts/online/tv.sh -l http://followshows.com/feed/CCGYc -o ${watch_dir}",
    hour    => 4,
    minute  => 30,
    user    => $user,
  }

}
