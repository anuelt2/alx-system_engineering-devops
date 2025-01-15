# Install and configure Nginx server

exec { 'apt_update':
  command  => '/usr/bin/apt-get update',
  path     => ['/usr/sbin', '/usr/bin'],
  provider => 'shell'
}

package { 'Nginx':
  ensure  => 'installed',
  require => Exec['apt_update'],
}

file { '/var/www/html/index.html':
  ensure  => 'present',
  content => 'Hello World!\n',
  require => Package['Nginx'],
}

file { '/var/www/html/404.html':
  ensure  => 'present',
  content => "Ceci n'est pas une page\n",
  require => Package['Nginx'],
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
  require => Package['Nginx'],
}

exec { 'nginx_restart':
  command => '/usr/bin/service nginx restart',
  path    => ['/usr/sbin', '/usr/bin'],
  require => '/etc/nginx/sites-available/default',
}

service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Exec['nginx_restart'],
}
