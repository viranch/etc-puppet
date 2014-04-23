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
        command => "/opt/scripts/online/tv.sh -a -l ${link} -o ${watch_dir}",
        hour    => 4,
        minute  => 30,
        user    => $user,
      }

      file {
        "tv-${user}.conf":
          path => "${home}/.tv.conf",
          source => "puppet:///modules/tv/${user}.conf",
          owner => $user, mode => 640;

        $watch_dir:
          ensure => directory,
          owner => $user;
      }
    }
  }
}
