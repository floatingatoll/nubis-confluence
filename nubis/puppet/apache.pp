
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
    mpm_module          => 'prefork',
    keepalive_timeout   => '30',
}

class { 'apache::mod::remoteip':
    proxy_ips => [ '127.0.0.1', '10.0.0.0/8' ]
}

include apache::mod::proxy
include apache::mod::proxy_http
include apache::mod::headers

#apache::custom_config { 'hostname.conf':
#    content => "Header always set X-Backend-Server ${::fqdn}"
#}

apache::vhost { $vhost_name:
    port            => '80',
    docroot         => '/var/www/html',
    default_vhost   => true,
    redirect_status => 'permanent',
    redirect_dest   => "http://${::vhost_name}/wiki",
    aliases         => [
        {
            aliasmatch => '/robots.txt',
            path       => '/opt/atlassian/confluence/robots.txt'
        }
    ],
    #rewrites => [
    #    {
    #        comment      => 'bug 1022964',
    #        rewrite_cond => [ '%{REQUEST_URI} !^/(wiki|robots\.txt)' ],
    #        rewrite_rule => [ '^/(.*)$        https://mana.allizom.org/wiki/$1 [R=302,L]']
    #    }
    #],
    directories => [
        {
            path     => '/wiki/s',
            provider => 'location',
            require  => 'all granted',
        },
        {
            path     => '/wiki',
            provider => 'location',
            require  => 'all granted',
            headers  => 'always set Strict-Transport-Security "max-age=2629744; includeSubdomains"',
        },
    ],
    proxy_preserve_host => true,
    proxy_pass          => [
        {
            path    => '/wiki',
            url     => 'http://127.0.0.1:8090/wiki',
        }
    ],
    proxy_dest_reverse_match => [
        {
            path    => '/wiki',
            url     => 'http://127.0.0.1:8090/wiki'
        }
    ],
}
