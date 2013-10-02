class icinga {
  include apache

  package { 'icinga':
    ensure => latest,
    require => Package['apache'],
  }

  service { 'icinga':
    ensure => running,
    enable => true,
    require => Package['icinga']
  }

  File {
    notify => Service['icinga']
  }
}
