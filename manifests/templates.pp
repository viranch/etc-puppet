class base-node($user) {

  $packages = ['git']

  package { $packages: ensure => installed }

  $home = "/home/${user}"
  $the_user = $user

  exec { 'clone-dotfiles':
    command => "/usr/bin/git clone git://github.com/viranch/dotfiles.git ${home}/.dotfiles",
    user => $the_user,
    creates => "${home}/.dotfiles",
    require => User[$user],
  }

  exec { 'pull-dotfiles':
    command => '/usr/bin/git pull',
    user => $the_user,
    cwd => "${home}/.dotfiles",
    require => Exec['clone-dotfiles'],
  }

  exec { 'run-setup-script':
    command => "${home}/.dotfiles/setup.sh",
    user => $the_user,
    require => Exec['pull-dotfiles'],
  }

}
