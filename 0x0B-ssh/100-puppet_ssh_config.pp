# Make changes to SSH config file

file { '/home/anuel/.ssh/config':
  ensure  => 'present',
  mode    => '0600',
  content => 'Host *'
}

exec { 'set_identityfile':
  command => 'echo "	IdentityFile ~/.ssh/school" >> /home/anuel/.ssh/config',
  path    => '/bin/',
  require => Exec['add_newline'],
}

exec { 'set_passwordauthentication':
  command => 'echo "	PasswordAuthentication no" >> /home/anuel/.ssh/config',
  path    => '/bin/',
  require => Exec['add_newline'],
}

exec { 'add_newline':
  command => 'echo "" >> /home/anuel/.ssh/config',
  path    => '/bin/',
  require => File['/home/anuel/.ssh/config'],
}
