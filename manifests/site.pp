import "templates"

node /^ip-.*$/ {

  $packages = ['zsh']
  $user = 'arch'

  package { $packages: ensure => installed }

  user { $user:
    managehome => true,
    shell => '/bin/zsh',
    require => Package['zsh'],
  }

  class { 'base-node':
    user => $::user,
  }

  class { 'transmission':
    user => $::user,
    require => User[$user],
  }

  file { '/etc/ssh/sshd_config':
    source => 'puppet:///modules/sshd/sshd_config',
    owner => root, group => root, owner => 644,
  }

}
