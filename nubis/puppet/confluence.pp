
package { 'java-1.7.0-openjdk':
    ensure => present,
}

package { 'libXp':
    ensure => present
}

package { 'libXp-devel':
    ensure => present,
}
