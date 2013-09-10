class quassel {

  package { 'quassel-core': ensure => installed }

  service { 'quassel':
    ensure => running,
    enable => true,
  }

}
