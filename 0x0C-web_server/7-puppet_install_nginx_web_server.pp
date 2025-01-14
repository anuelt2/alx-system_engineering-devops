# Install and configure Nginx server
# Configure Nginx to listen on port 80
# Redirection must be a 301 Moved Permanently

exec { 'apt_update':
  command => 'sudo apt-get update',
  path    => '/bin/:/usr/bin/',
}

package { 'Nginx':
  ensure  => 'installed',
  require => Exec['apt_update'],
}

file { '/var/www/html/index.html':
  content => 'Hello World!',
}

exec { 'add_redirect_directive':
  command  => "sudo sed -i '/server_name _;/a\\\trewrite ^/redirect_me https://www.youtube.com/watch?v=9t9Mp0BGnyI permanent;' /etc/nginx/sites-available/default",
  path     => '/bin/:/usr/bin/',
  provider => 'shell',
}

service { 'nginx':
  ensure  => 'running',
  require => Package['Nginx'],
}
