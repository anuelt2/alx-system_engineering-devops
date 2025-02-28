# Puppet manifest to fix typo in /var/www/html/wp-settings.php

file { '/var/www/html/wp-settings.php':
  ensure => 'present',
}

exec { 'fix_typo_wp_settings':
  command => "sed -i 's/.phpp/.php/g' /var/www/html/wp-settings.php",
  path    => '/bin/:/usr/bin/:/sbin/:/usr/sbin/',
  require => File['/var/www/html/wp-settings.php'],
}
