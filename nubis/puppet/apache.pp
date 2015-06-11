
$vhost_name = 'confluence.sandbox.nubis.allizom.org'

if $::osfamily == 'debian' {
    exec { 'aptitude-update':
        command => '/usr/bin/aptitude update',
    }->
    package { 'apache2-utils':
        ensure => installed,
    }
}

class { 'apache':
    default_mods        => true,
    default_vhost       => false,
    default_confd_files => false,
    mpm_module          => 'prefork'
}

class { 'apache::mod::remoteip':
    proxy_ips => [ '127.0.0.1', '10.0.0.0/8' ]
}

apache::mod { 'proxy': }
apache::mod { 'headers': }

apache::vhost { 'default':
    port          => '80',
    servername    => $::fqdn,
    default_vhost => true,
    docroot       => '/var/www/html',
}

apache::vhost { $vhost_name:
    port    => '80',
    docroot => '/var/www/html',
    aliases => [
        {
            aliasmatch => '/robots.txt',
            path       => '/opt/atlassian/confluence/robots.txt'
        }
    ],
    rewrites => [
        {
            comment      => 'bug 1022964',
            rewrite_cond => [ '%{REQUEST_URI} !^/(wiki|robots\.txt)' ],
            rewrite_rule => [ '^/(.*)$        https://mana.allizom.org/wiki/$1 [R=302,L]']
        }
    ],
    directories => [
        {
            path     => '/wiki/s',
            provider => 'location',
            require  => 'all granted',
        }
    ],
    proxy_preserve_host => false,
    additional_includes => [
        '/etc/apache2/conf-enabled/mana.mozilla.org.conf'
    ],
    #access_log_format   => "${log_prefix}/${vhost_name}/access_%Y-%m-%d-%H 3600 -0 combined",
    #access_log_pipe     => $::osfamily ? {
    #    'redhat'    => '|/usr/sbin/rotatelogs',
    #    'debian'    => '|/usr/bin/rotatelogs',
    #    default => fail("Package apache2-utils not installed")
    #},
}
