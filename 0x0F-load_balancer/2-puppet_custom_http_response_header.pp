# Install and configure Nginx server
# Create a custom HTTP header response

exec { 'apt-update':
  command => '/usr/bin/apt-get -y update',
  path    => ['/usr/sbin', '/usr/bin'],
}

package { 'nginx':
  ensure  => 'installed',
}

file_line { 'custom_http_response_header':
  ensure => 'present',
  path   => '/etc/nginx/sites-available/default',
  line   => "\tadd_header X-Served-By \"${hostname}\";",
  after  => 'server_name _;',
}

service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Package['nginx'],
}

exec { 'restart_nginx':
  command  => 'sudo service nginx restart',
  provider => 'shell',
  require  => File_line['custom_http_response_header']
}
