class base-node {

  $admin = hiera('admin', 'admin', 'users')

  include users

  service { 'cronie':
    ensure => running,
    enable => true,
  }

  include git

  $home = "/home/${admin}"

  define admin_repo($repo_dir) {
    git::repo { $name:
      url => "git://github.com/${admin}/${name}.git",
      location => "${home}/${repo_dir}",
      as_user => $admin,
      require => User[$admin],
    }
  }

  admin_repo {
    'dotfiles':
      repo_dir => '.dotfiles';
  }

  git::repo { 'scripts':
    url => "git://github.com/viranch/scripts.git",
    location => "/opt/scripts",
    as_user => 'root',
  }

  $packages = [ 'python2', 'dnsutils', 'inetutils', 'ncdu', 'python2-lxml', 'yaourt' ]

  package { $packages: ensure => installed }

  include security

}
