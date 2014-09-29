class icinga::conf {

  file {
    '/etc/icinga/conf.d':
      ensure => directory,
      recurse => true,
      notify => Service['icinga'],
      source => 'puppet:///modules/icinga/conf.d';

    '/etc/icinga':
      ensure => directory,
      recurse => true,
      notify => Service['icinga'],
      source => 'puppet:///modules/icinga/conf';
  }

  # setup push

  $users_data = hiera('users', $default, 'transmission')
  $admin_user = hiera('admin','','users')
  $admin_user_data = $users_data[$admin_user]

  if ($admin_user_data != '') {
    $email = $admin_user_data['email']

    file { "/opt/scripts/push":
      content => template('transmission/push.erb'),
      mode    => 644,
    }
  }

}
