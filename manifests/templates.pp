class base-node($user) {

  include git

  $home = "/home/${user}"

  git::repo { 'dotfiles':
    url => "git://github.com/viranch/dotfiles.git",
    location => "${home}/.dotfiles",
    as_user => $user,
    require => User[$user],
  }

  $the_user = $user
  exec { 'run-setup-script':
    command => "${home}/.dotfiles/setup.sh",
    user => $the_user,
    require => Git::Repo['dotfiles'],
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

}
