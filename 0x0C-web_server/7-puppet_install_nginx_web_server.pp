# Install and configure Nginx server
# Configure Nginx to listen on port 80
# Redirection must be a 301 Moved Permanently

exec { 'apt_update':
  command  => 'sudo apt-get update -y',
  path     => '/bin/:/usr/bin/',
  provider => 'shell'
}

package { 'Nginx':
  ensure  => 'installed',
  require => Exec['apt_update'],
}

exec { 'ufw_allow_HTTP':
  command => "sudo ufw allow 'Nginx HTTP'",
  path    => '/usr/sbin/:/usr/bin/',
  require => Package['Nginx'],
}

exec { 'ufw_allow_OpenSSH':
  command => 'sudo ufw allow OpenSSH',
  path    => '/usr/sbin/:/usr/bin/',
  require => Exec['ufw_allow_HTTP'],
}

exec { 'ufw_enable':
  command => 'sudo ufw enable',
  path    => '/usr/sbin/:/usr/bin/',
  unless  => "sudo ufw status | grep -q 'Status: active'",
  require => Exec['ufw_allow_OpenSSH'],
}

file { '/var/www/html/index.html':
  ensure  => 'present',
  content => 'Hello World!',
  require => Package['Nginx'],
}

file { '/var/www/html/404.html':
  ensure  => 'present',
  content => "Ceci n'est pas une page",
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
  command => 'sudo service nginx restart',
  path    => '/usr/sbin/:/usr/bin/',
  require => '/etc/nginx/sites-available/default',
}

service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Exec['nginx_restart'],
}
