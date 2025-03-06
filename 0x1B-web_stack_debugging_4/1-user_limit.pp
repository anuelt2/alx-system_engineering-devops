# Puppet manifest to increase nofile limit of holberton user

exec { 'increase_nofile_hard_holberton_user':
  command => "sed -i 's/holberton hard nofile 5/holberton hard nofile 50000/g' /etc/security/limits.conf",
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}

exec { 'increase_nofile_soft_holberton_user':
  command => "sed -i 's/holberton soft nofile 4/holberton soft nofile 40000/g' /etc/security/limits.conf",
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}
