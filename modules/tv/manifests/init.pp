class tv {
  $users = hiera('users', [], 'users')

  setup_tv { $users:
    require => User[$users],
  }

  define setup_tv() {
    $user = $name
    $home = "/home/${user}"
    $link = hiera("${user}-link", '', 'tv')

    if ($link != '') {
      $watch_dir = "${home}/watch"

      cron { "tv-${user}":
        command => "/opt/scripts/online/tv.sh -l ${link} -o ${watch_dir} -s 720p >> \$HOME/`basename ${link}`.log",
        hour    => 4,
        minute  => 30,
        user    => $user,
      }

      file {
        $watch_dir:
          ensure => directory,
          owner => $user;
      }
    }
  }
}
