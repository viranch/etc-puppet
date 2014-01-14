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
      $link = ''
      $port = '9000'
      $email = ''
    }
    else {
      $password = $user_data['password']
      $link = $user_data['link']
      $port = $user_data['port']
      $email = $user_data['email']
    }

    $email_notify = hiera('notifications', $default, 'transmission')
    $em_username = $email_notify['user']
    $em_pass = $email_notify['password']

    $config_dir = "${home}/.config/transmission-daemon"
    $watch_dir = "/tmp/watch-${user}"
    $download_dir = "${home}/Downloads"
    $dirs = [$config_dir, "${home}/.config",
      $watch_dir, $download_dir]

    file { $dirs:
      ensure => directory,
      owner => $user,
      require => Package['transmission-cli'],
    }

    file { "${user}-settings.json":
      path => "${config_dir}/settings.json",
      content => template('transmission/settings.erb'),
      owner => $user, mode => 600,
      require => File[$dirs],
    }

    file { "tv-${user}.conf":
      path => "${home}/.tv.conf",
      source => "puppet:///modules/transmission/tv-${user}.conf",
      owner => $user, mode => 640,
    }

    if ($link != '') {
      cron { "tv-${user}":
        command => "/opt/scripts/online/tv.sh -a -l ${link} -o ${watch_dir}",
        hour    => 4,
        minute  => 30,
        user    => $user,
      }
    }

    if ($email != '') {
      file { "${home}/.gmail":
        content => template('transmission/email.erb'),
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
