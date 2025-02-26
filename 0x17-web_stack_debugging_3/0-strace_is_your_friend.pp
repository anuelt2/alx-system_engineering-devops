# Puppet manifest to fix typo in /var/www/html/wp-settings.php

file { '/var/www/html/wp-settings.php':
  ensure => 'present',
}

exec { 'fix_typo_wp_settings':
  command => "sed -i 's/phpp/php/g' /var/www/html/wp-settings.php",
  path    => '/bin/:/usr/bin/:/usr/sbin/',
  require => File['/var/www/html/wp-settings.php'],
  notify  => Service['apache2'],
}

service {'apache2':
  ensure     => 'running',
  enable     => true,
  hasrestart => true,
  require    => Exec['fix_typo_wp_settings']
}
