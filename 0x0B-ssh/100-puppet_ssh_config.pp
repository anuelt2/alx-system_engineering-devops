#!/usr/bin/env bash
# Make changes to SSH config file

file { '/etc/ssh/ssh_config':
  ensure => 'present',
}

file_line { 'set_identityfile':
  path    => '/etc/ssh/ssh_config',
  line    => 'IdentityFile ~/.ssh/school',
  match   => '^IdentityFile',
  replace => 'true',
}

file_line { 'set_passwordauthentication':
  path    => '/etc/ssh/ssh_config',
  line    => 'PasswordAuthentication no',
  match   => 'PasswordAuthentication yes',
  replace => 'true',
}
