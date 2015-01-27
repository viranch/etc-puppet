class security {
  # homebrew fail2ban
  cron { 'ban-ssh':
    command => '/opt/scripts/system/ban_ssh.sh',
    user    => 'root',
    hour    => 23,
    minute  => 59,
  }
}
