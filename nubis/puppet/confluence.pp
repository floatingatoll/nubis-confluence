class confluence (
    $version
) {

    $download_link = "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${version}.tar.gz"

    package { 'java-1.7.0-openjdk':
        ensure => present,
    }

    package { 'libXp':
        ensure => present,
    }

    package { 'libXp-devel':
        ensure => present,
    }

    group { 'confluence':
        ensure => present,
    }

    user { 'confluence':
        ensure  => present,
        home    => '/data/confluence',
        shell   => '/bin/bash',
        require => Group['confluence'],
    }

    file { '/data':
        ensure  => directory,
    }

    file { '/data/confluence':
        ensure  => directory,
        owner   => confluence,
        group   => confluence,
        mode    => '0755',
        require => [ File['/data'], User['confluence']],
    }

    file { '/opt':
        ensure => directory,
    }

    file { '/opt/atlassian':
        ensure  => directory,
        owner   => confluence,
        group   => confluence,
        require => File['/opt'],
    }

    file { "/var/run/confluence":
        ensure => directory,
        owner  => confluence,
        group  => confluence,
        mode   => '0755',
    }

    # download file if it doesn't exist
    exec { "download atlassian version ${version}":
        path    => ["/usr/bin", "/bin", "/usr/sbin", "/sbin"],
        command => "wget -P /usr/local/src ${download_link}",
        unless  => "test -f /usr/local/src/atlassian-confluence-${version}.tar.gz",
        notify  => Exec["unpack confluence version ${version}"],
    }

    exec { "unpack confluence version ${version}":
        path        => ["/usr/bin", "/bin", "/usr/sbin", "/sbin"],
        command     => "tar -xzf /usr/local/src/atlassian-confluence-${version}.tar.gz -C /opt/atlassian",
        refreshonly => true,
        require     => File['/opt/atlassian'],
    }
}

class { 'confluence':
    version =>  '5.8.4'
}
