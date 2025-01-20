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

file { '/etc/nginx/sites-available/default':
  ensure  => 'present',
  content => '
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;

	index index.html index.htm index.nginx-debian.html;

	server_name _;

	add_header X-Served-By $hostname;

	location / {
		try_files $uri $uri/ =404;
	}
}',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Package['nginx'],
}
