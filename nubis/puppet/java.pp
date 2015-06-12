
# Totally sucks we have to do this
apt::ppa { 'ppa:webupd8team/java': }

exec { 'aptitude update':
    command => '/usr/bin/aptitude'
}

package { 'oracle-java8-installer':
    ensure  => installed
    require => Exec['aptitude update']
}
