node 'viranch.me' {
  include base-node

  $admin = hiera('admin', 'admin', 'users')

  ### sshd_config ###
  file { '/etc/ssh/sshd_config':
    source => 'puppet:///modules/sshd/sshd_config',
    owner => root, group => root, mode => 644,
  }

  ### quassel ###
  include quassel

}
