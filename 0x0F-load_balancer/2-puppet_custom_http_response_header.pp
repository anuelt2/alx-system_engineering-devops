# Install and configure Nginx server
# Create a custom HTTP header response

exec { 'apt-update':
  command  => '/usr/bin/apt-get update -y',
  path     => ['/usr/sbin', '/usr/bin'],
  provider => 'shell',
}

package { 'nginx':
  ensure  => 'installed',
  require => Exec['apt-update'],
}

file_line { 'custom_http_header':
  ensure => 'present',
  path   => '/etc/nginx/sites-available/default',
  line   => "\tadd_header X-Served-By ${hostname};",
  after  => 'server_name _;',
}

service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Package['nginx'],
}
