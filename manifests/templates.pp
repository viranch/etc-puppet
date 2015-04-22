class base-node {

  $username = hiera('username', 'admin', 'users')

  include users

  service { 'cronie':
    ensure => running,
    enable => true,
  }

  include git

  $home = "/home/${username}"

  define user_repo($username, $repo_dir) {
    git::repo { $name:
      url => "git://github.com/viranch/${name}.git",
      location => "/home/${username}/${repo_dir}",
      as_user => $username,
      require => User[$username],
    }
  }

  user_repo {
    'dotfiles':
      username => $username,
      repo_dir => '.dotfiles';

    'docker-vps':
      username => $username,
      repo_dir => 'vps';

    'scripts':
      username => $username,
      repo_dir => 'playground/.scripts';
  }

  $packages = [ 'python2', 'dnsutils', 'inetutils', 'ncdu', 'python2-lxml', 'yaourt' ]

  package { $packages: ensure => installed }

  include security

}
