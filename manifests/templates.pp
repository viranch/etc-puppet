class base-node($user) {

  class { 'users':
    username => $user,
  }

  service { 'cronie':
    ensure => running,
    enable => true,
  }

  include git

  $home = "/home/${user}"

  git::repo { 'dotfiles':
    url => "git://github.com/viranch/dotfiles.git",
    location => "${home}/.dotfiles",
    as_user => $user,
    require => User[$user],
  }

  $scripts_dir = "${home}/playground"

  git::repo { 'scripts':
    url => "git://github.com/viranch/scripts.git",
    location => "${scripts_dir}/scripts",
    as_user => $user,
    require => [ User[$user], File[$scripts_dir] ],
  }

  file { $scripts_dir:
    ensure => directory,
    owner => $user,
    require => User[$user],
  }

  $packages = [ 'python2' ]

  package { $packages: ensure => installed }

}
