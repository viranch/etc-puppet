class git {

  package { 'git': ensure => installed }

  define repo($url, $location, $as_user) {
    exec {
      "clone-${name}":
        command => "/usr/bin/git clone ${url} ${location}",
        user => $as_user,
        creates => $location;

      "pull-${name}":
        command => "/usr/bin/git pull ${url}",
        user => $as_user,
        cwd => $location,
        require => Exec["clone-${name}"];
    }
  }

}
