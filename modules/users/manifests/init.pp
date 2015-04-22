class users {

  $packages = ['zsh', 'sudo', 'tmux']

  package { $packages: ensure => installed }

  $username = hiera('username', 'admin', 'users')

  user { $username:
    ensure => present,
    managehome => true,
    shell => '/bin/zsh',
    require => Package['zsh'],
  }

  file { '/etc/sudoers':
    content => template('users/sudoers.erb'),
    owner => root, group => root, mode => 440,
    require => Package['sudo'],
  }

  file { "/home/${username}":
    ensure  => directory,
    mode    => 755,
    require => User[$username];
  }
}
