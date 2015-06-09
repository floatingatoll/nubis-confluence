
$vhost_name = 'mana.nubis.allizom.org'

class { 'apache':
    default_mods        => true,
    default_vhost       => false,
    default_confd_files => false,
    mpm_module          => 'prefork'
}
