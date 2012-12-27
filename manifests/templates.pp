class base-node($user) {

  $packages = ['git']

  package { $packages: ensure => installed }

  $home = "/home/${user}"

  exec { 'clone-dotfiles':
    command => "/usr/bin/git clone git://github.com/viranch/dotfiles.git ${home}/.dotfiles",
    user => "${base-node::user}",
    creates => "${home}/.dotfiles",
    require => User[$user],
  }

  exec { 'pull-dotfiles':
    command => '/usr/bin/git pull',
    user => "${base-node::user}",
    cwd => "${home}/.dotfiles",
    require => Exec['clone-dotfiles'],
  }

  exec { 'run-setup-script':
    command => "${home}/.dotfiles/setup.sh",
    user => "${base-node::user}",
    require => Exec['pull-dotfiles'],
  }

}
