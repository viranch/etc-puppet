class users($username) {

  $packages = ['zsh', 'sudo']

  package { $packages: ensure => installed }

  user { $username:
    managehome => true,
    shell => '/bin/zsh',
    require => Package['zsh'],
  }

  file { '/etc/sudoers':
    content => template('users/sudoers.erb'),
    owner => root, group => root, mode => 440,
    require => Package['sudo'],
  }

}
