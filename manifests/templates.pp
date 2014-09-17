class base-node {

  $admin = hiera('admin', 'admin', 'users')

  include users

  service { 'cronie':
    ensure => running,
    enable => true,
  }

  include git

  $home = "/home/${admin}"

  git::repo { 'dotfiles':
    url => "git://github.com/viranch/dotfiles.git",
    location => "${home}/.dotfiles",
    as_user => $admin,
    require => User[$admin],
  }

  git::repo { 'scripts':
    url => "git://github.com/viranch/scripts.git",
    location => "/opt/scripts",
    as_user => 'root',
  }

  $packages = [ 'python2', 'dnsutils', 'inetutils', 'ncdu', 'python2-lxml', 'yaourt' ]

  package { $packages: ensure => installed }

}
