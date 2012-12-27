node /^ip-.*$/ {

  user { 'arch':
    managehome => true,
  }

  class { 'transmission':
    user => 'arch',
    require => User['arch'],
  }
}
