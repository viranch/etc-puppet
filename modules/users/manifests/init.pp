class users {

  $packages = ['zsh', 'sudo', 'tmux']

  package { $packages: ensure => installed }

  $users = hiera('users', [], 'users')

  create_user { $users: }

  define create_user() {
    $username = $name

    if ($username == hiera('admin', '', 'users')) {
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
    }
    else {
      user { $username:
        ensure => present,
        managehome => true,
      }
    }
  }
}
