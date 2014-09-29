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

  # setup push

  $users_data = hiera('users', $default, 'transmission')
  $admin_user = hiera('admin','','users')
  $admin_user_data = $users_data[$admin_user]

  if ($admin_user_data != '') {
    $email = $admin_user['email']

    file { "/opt/scripts/push":
      content => template('transmission/push.erb'),
      mode    => 644,
    }
  }

}
