# Install and configure Nginx server
# Configure Nginx to listen on port 80
# Redirection must be a 301 Moved Permanently

exec { 'apt_update':
  command => 'sudo apt-get update -y',
  path    => '/bin/:/usr/bin/',
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
  require => Exec['ufw_enable'],
}

exec { 'add_redirect_directive':
  command => @(CMD), REDIRECT_URL='https://www.youtube.com/watch?v=9t9Mp0BGnyI';
  REDIRECT_BLOCK=$(printf '\\tlocation /redirect_me {\\\\n\\t\\treturn 301 %s;\\\\n\\t}' "$REDIRECT_URL");
  sudo sed -i '/server_name _;/a\\\\'$REDIRECT_BLOCK'' /etc/nginx/sites-available/default
  | CMD,
  path    => '/bin/:/usr/bin/',
  unless  => "grep -q 'location /redirect_me' /etc/nginx/sites-available/default",
  require => Exec['ufw_enable'],
}

service { 'nginx':
  ensure    => 'running',
  enable    => true,
  subscribe => File['/etc/nginx/sites-available/default'],
  require   => Package['Nginx'],
}
