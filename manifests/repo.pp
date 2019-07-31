# == Class: logstashforwarder::repo
#
# This class exists to install and manage yum and apt repositories
# that contain logstashforwarder official logstashforwarder packages
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'logstashforwarder::repo': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Phil Fenstermacher <mailto:phillip.fenstermacher@gmail.com>
# * Ricahrd Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
class logstashforwarder::repo(
  $ensure = 'absent',
){

  case $::osfamily {
    'Debian': {
      if !defined(Class['apt']) {
        class { 'apt': }
      }

      apt::source { 'logstashforwarder':
        ensure      => $ensure,
        location    => 'http://packages.elasticsearch.org/logstashforwarder/debian',
        release     => 'stable',
        repos       => 'main',
        key         => {
          'id'     => 'D88E42B4',
          'server' => 'pgp.mit.edu',
        },
      }
    }
    'RedHat': {
      yumrepo { 'logstashforwarder':
        ensure   => $ensure,
        baseurl  => 'http://packages.elasticsearch.org/logstashforwarder/centos',
        gpgcheck => 1,
        gpgkey   => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
        enabled  => 1,
      }
    }
    default: {
      fail("\"${module_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
    }
  }
}
