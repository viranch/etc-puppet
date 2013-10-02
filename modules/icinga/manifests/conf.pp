class icinga::conf {

  File {
    ensure => directory,
    recurse => true,
    notify => Service['icinga'],
  }

  file {
    '/etc/icinga/conf.d':
      source => 'puppet:///modules/icinga/conf.d';

    '/etc/icinga':
      source => 'puppet:///modules/icinga/conf';
  }

}
