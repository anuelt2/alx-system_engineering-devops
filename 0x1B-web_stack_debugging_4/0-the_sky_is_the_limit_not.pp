# Puppet manifest to increase ulimit of nginx server

exec { 'increase_ulimit':
  command => "sed -i 's/ULIMIT=\"-n 15\"/ULIMIT=\"-n 4096\"/g' /etc/default/nginx",
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}

exec { 'nginx_stop':
  command => 'service nginx stop',
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
}

exec { 'nginx_start':
  command => 'service nginx start',
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
  require => Exec['nginx_stop'],
}
