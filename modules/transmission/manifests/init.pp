class transmission {

  package { 'transmission-cli': ensure => installed }

  $users = hiera('users', [], 'users')

  configure { $users:
    require => User[$users],
  }

  define configure() {
    $user = $name
    $home = "/home/${user}"

    $default = {}
    $users_data = hiera('users', $default, 'transmission')
    $user_data = $users_data[$user]
    if ($user_data == '') {
      $password = ''
      $port = '9000'
      $email = ''
    }
    else {
      $password = $user_data['password']
      $port = $user_data['port']
      $email = $user_data['email']
    }

    $config_dir = "${home}/.config/transmission-daemon"
    $download_dir = "${home}/Downloads"
    $dirs = [$config_dir, "${home}/.config", $download_dir]

    file { $dirs:
      ensure => directory,
      owner => $user,
      require => Package['transmission-cli'],
    }

    $watch_dir = "/tmp/watch-${user}"

    file { "${user}-settings.json":
      path => "${config_dir}/settings.json",
      content => template('transmission/settings.erb'),
      owner => $user, mode => 600,
      require => File[$dirs],
    }

    if ($email != '') {
      file { "${home}/.push":
        content => template('transmission/push.erb'),
        owner => $user, mode => 640,
      }
    }

    cron { "transmissiond-${user}":
      command => '/usr/bin/transmission-daemon',
      special => 'reboot',
      user => $user,
    }

  }

}
