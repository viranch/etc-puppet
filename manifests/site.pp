import "templates"

node 'lazybit' inherits base-node {

  $admin = hiera('admin', 'admin', 'users')

  ### sshd_config ###
  file { '/etc/ssh/sshd_config':
    source => 'puppet:///modules/sshd/sshd_config',
    owner => root, group => root, mode => 644,
  }

  ### transmission ###
  class { 'transmission': require => Class['users'] }

  ### http server ###
  $port = '8080'
  include apache

  ### quassel ###
  include quassel

  ### icinga ###
  include icinga
  include icinga::conf
  include icinga::web

}
