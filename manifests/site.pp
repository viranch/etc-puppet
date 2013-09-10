import "templates"

node /^.*$/ {

  $user = 'viranch'

  ### sshd_config ###
  file { '/etc/ssh/sshd_config':
    source => 'puppet:///modules/sshd/sshd_config',
    owner => root, group => root, mode => 644,
  }

  ### user setup ###
  class { 'base-node':
    user => $::user,
  }

  ### transmission ###
  class { 'transmission':
    user => $::user,
    require => User[$user],
  }

  ### http server ###
  $port = '8080'
  include apache

  file { '/srv/http/stuff':
    ensure => link,
    target => "/home/${user}/Downloads",
    require => Class['apache', 'transmission'],
  }

  ### quassel ###
  include quassel

}
