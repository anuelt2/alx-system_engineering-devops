# Install flask version 2.1.0 from pip3
package { 'Flask':
  ensure   => '2.1.0',
  provider => 'pip3',
  require  => Package['python3-pip'],
}

package { 'python3.8':
  ensure => 'installed',
}

package { 'python3-pip':
  ensure  => 'installed',
  require => Package['python3.8'],
}

package { 'Werkzeug':
  ensure   => '2.1.1',
  provider => 'pip3',
  require  => Package['python3-pip'],
}
