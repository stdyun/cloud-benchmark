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
    require => Exec["clone_mbw"],
}

file { "${dir}/iozone":
    ensure => "directory",
    before => Exec["iozone"],
}

$memory = inline_template("<%
        mem,unit = scope.lookupvar('::memorysize').split
        mem = mem.to_f
        case unit
        when nil:  mem *= (1<<0)
        when 'kB': mem *= (1<<00)
        when 'MB': mem *= (1<<10)
        when 'GB': mem *= (1<<20)
        when 'TB': mem *= (1<<30)
        end
        mem *= 2
        %><%= mem.to_i %>")

exec { "iozone":
    cwd => "${dir}/iozone",
    command => "iozone -Mcew -i0 -i1 -i2 -s${memory} -r256k -f iozone.tmp > iozone-`date +%F-%H-%M-%S`.log",
}

exec { "wget_unixbench":
    command => "wget http://byte-unixbench.googlecode.com/files/UnixBench5.1.3.tgz -O unixbench-5.1.3.tgz",
}

file { "${dir}/unixbench-5.1.3.tgz":
    ensure => "present",
    require => Exec["wget_unixbench"],
    before => Exec["tar_unixbench"],
}

exec { "tar_unixbench":
    command => "tar zxvf ${dir}/unixbench-5.1.3.tgz && mv ${dir}/UnixBench ${dir}/unixbench",
}

exec { "unixbench":
    cwd => "${dir}/unixbench",
    command => "ls && ./Run > unixbench-`date +%F-%H-%M-%S`.log",
    timeout => 0,
    require => Exec["tar_unixbench"],
}
