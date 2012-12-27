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
    require => User[$::user],
  }
}
