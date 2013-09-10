class quassel {

  package { 'quassel-core': ensure => installed }

  service { 'quassel':
    ensure => running,
    enable => true,
  }

  # exec: openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /var/lib/quassel/cert.pem -out /var/lib/quassel/cert.pem

}
