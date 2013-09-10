class git {

  package { 'git': ensure => installed }

  define repo($url, $location, $as_user) {
    exec { "clone-${name}":
      command => "/usr/bin/git clone ${url} ${location}",
      user => $as_user,
      creates => $location,
    }

    cron { "pull-${name}":
      command => "cd ${location} && /usr/bin/git pull",
      user => $as_user,
      minute => 0,
    }
  }

}
