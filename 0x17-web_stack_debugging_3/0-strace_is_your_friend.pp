# Puppet manifest to fix typo in /var/www/html/wp-settings.php

file { '/var/www/html/wp-settings.php':
  ensure => 'present',
}

exec { 'sed':
  command => 'sed -i s/phpp/php/g /var/www/html/wp-settings.php',
  path    => '/bin/:/usr/bin/:/usr/sbin/',
  require => File['/var/www/html/wp-settings.php'],
}

service {'apache2':
  ensure     => 'running',
  enable     => 'true',
  hasrestart => 'true',
}
