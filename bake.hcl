group "default" {
    targets = [ 
#        "centos-8",
#        "centos-stream-8",
#        "centos-stream-9",
        "debian-stable",
        "debian-testing",
        "debian-unstable",
        "fedora-37",
        "fedora-38",
#        "fedora-rawhide",
        "gentoo",
#        "opensuse-leap",
#        "opensuse-tumbleweed",
#        "ubuntu-bionic",
#        "ubuntu-focal",
#        "ubuntu-jammy",
#        "ubuntu-lunar",
#        "ubuntu-mantic"
        ]
}

target "default" {
    output = [ "type=registry" ]
    platforms = ["linux/amd64", "linux/arm64" ]
    secret = [ "type=env,http_proxy=http://n2:3128/" ]
    args =  {
        http_proxy="http://n2:3128"
    }
}

target "gentoo" {
    context = "gentoo"
    inherits = [ "default" ]
    platforms = ["linux/amd64", "linux/i386", "linux/arm64"]
    tags = [ "squidcache/buildfarm-gentoo:latest" ]
}

target "debian-unstable" {
    context = "debian-unstable"
    inherits = [ "default" ]
    platforms = ["linux/amd64", "linux/i386", "linux/arm64", "linux/arm/v7" ]
    tags = [ "squidcache/buildfarm-debian-unstable:latest" ]
}

target "debian-testing" {
    context = "debian-testing"
    inherits = [ "default" ]
    platforms = ["linux/amd64", "linux/i386", "linux/arm64", "linux/arm/v7" ]
    tags = [ "squidcache/buildfarm-debian-testing:latest" ]
}

target "debian-stable" {
    context = "debian-stable"
    inherits = [ "default" ]
    platforms = ["linux/amd64", "linux/i386", "linux/arm64", "linux/arm/v7" ]
    tags = [ "squidcache/buildfarm-debian-stable:latest" ]
}

target "fedora-37" {
    context = "fedora-37"
    inherits = [ "default" ]
    tags = [ "squidcache/buildfarm-fedora-37:latest" ]
}

target "fedora-38" {
    context = "fedora-38"
    inherits = [ "default" ]
    tags = [ "squidcache/buildfarm-fedora-38:latest" ]
}

target "fedora-rawhide" {
    context = "fedora-rawhide"
    inherits = [ "default" ]
    tags = [ "squidcache/buildfarm-fedora-rawhide:latest" ]
}


