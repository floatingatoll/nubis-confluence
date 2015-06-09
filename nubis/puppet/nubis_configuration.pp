include nubis_configuration

nubis::configuration{ 'mediawiki':
    format => "php",
    reload => "apachectl graceful",
}
