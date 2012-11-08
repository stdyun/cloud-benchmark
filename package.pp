exec { "update":
    command => $operatingsystem ? {
    "Ubuntu" => "apt-get update",
    "Debian" => "apt-get update",
    "CentOS" => "yum makecache",
    },
}

Exec {
    path => [
        '/usr/local/bin',
        '/opt/local/bin',
        '/usr/bin',
        '/usr/sbin',
        '/bin',
        '/sbin'],
    logoutput => true,
}

$package_name = $operatingsystem? {
    "Ubuntu" => ["build-essential", "iozone3"],
}

package {
    $package_name:
    ensure  => "installed",
    require => Exec['update'],
}
