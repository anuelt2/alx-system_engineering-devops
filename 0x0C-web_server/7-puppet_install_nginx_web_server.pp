# Install and configure Nginx server

exec { 'apt_update':
  command  => '/usr/bin/apt-get update',
  path     => ['/usr/sbin', '/usr/bin'],
  provider => 'shell'
}

package { 'nginx':
  ensure  => 'installed',
  require => Exec['apt_update'],
}

file { '/var/www/html/index.html':
  ensure  => 'present',
  content => "Hello World!\n",
  require => Package['nginx'],
}

file { '/var/www/html/404.html':
  ensure  => 'present',
  content => "Ceci n'est pas une page\n",
  require => Package['nginx'],
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

        location / {
                try_files $uri $uri/ =404;
        }

        location /redirect_me {
                return 301 https://www.youtube.com/watch?v=9t9Mp0BGnyI;
        }

        error_page 404 /404.html;
}',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Package['nginx'],
}
