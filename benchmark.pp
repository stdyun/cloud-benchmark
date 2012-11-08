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
    /Ubuntu/ => ["build-essential", "iozone3"],
}

package {
    $package_name:
    ensure  => "installed",
    require => Exec['update'],
}

$dir =  $id? {
    "root" => "/root",
    default => "/home/$id",
}

exec { "clone_mbw":
    command => "git clone https://github.com/raas/mbw.git",
    creates => "${dir}/mbw",
}

exec { "mbw":
    cwd => "${dir}/mbw",
    command => "make && ./mbw 16 > mbw-`date +%F-%H-%M-%S`.log",
    require => exec["clone_mbw"],
}

file { "${dir}/unixbench-5.1.3.tgz":
    ensure => "present",
    require => exec["wget_unixbench"],
    before => exec["tar_unixbench"],
}


exec { "wget_unixbench":
    command => "wget http://byte-unixbench.googlecode.com/files/UnixBench5.1.3.tgz -O unixbench-5.1.3.tgz",
}

exec { "tar_unixbench":
    command => "tar zxvf ${dir}/unixbench-5.1.3.tgz && mv ${dir}/UnixBench ${dir}/unixbench",
}

exec { "unixbench":
    cwd => "${dir}/unixbench",
    command => "ls && ./Run > unixbench-`date +%F-%H-%M-%S`.log",
    timeout => 0,
    require => exec["tar_unixbench"],
}

file { "${dir}/iozone":
    ensure => "directory",
    before => exec["iozone"],
}

exec { "iozone":
    cwd => "${dir}/iozone",
    command => "iozone -Mcew -i0 -i1 -i2 -s4g -r256k -f iozone.tmp > iozone-`date +%F-%H-%M-%S`.log",
}
