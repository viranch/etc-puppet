import "templates"

node /^ip-.*$/ {

  ### Misc stuff ###
  $packages = ['zsh']
  $user = 'arch'

  package { $packages: ensure => installed }

  user { $user:
    managehome => true,
    shell => '/bin/zsh',
    require => Package['zsh'],
  }

  ### sshd_config ###
  file { '/etc/ssh/sshd_config':
    source => 'puppet:///modules/sshd/sshd_config',
    owner => root, group => root, mode => 644,
  }

  ### dotfiles + scripts ###
  class { 'base-node':
    user => $::user,
  }

  ### transmission ###
  class { 'transmission':
    user => $::user,
    require => User[$user],
  }

  ### http server ###
  include apache

  file { '/srv/http/stuff':
    ensure => link,
    target => "/home/${user}/Downloads",
    require => Class['apache', 'transmission'],
  }

}
