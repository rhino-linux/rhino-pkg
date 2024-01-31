use "./cmd-exist.nu" main

export def main [manager: string] -> string {
    let package: string = $in
    if $manager == 'apt' {
        return ($package | apt-fetch-version)
    } else if $manager == 'pacstall' {
        return ($package | pacstall-fetch-version)
    } else if $manager == 'flatpak' {
        return ($package | flatpak-fetch-version)
    } else if $manager == 'snap' {
        return ($package | snap-fetch-version)
    } else {
       return NO_VERSION_INSTALLED
    }
}

def NO_VERSION_INSTALLED [] -> string {
    $"(ansi red_bold)✕(ansi reset)"
}

def apt-fetch-version [] -> string {
    let package: string = $in
    let version = if (cmd-exist 'apt') {
        let query_complete = do { ^dpkg-query --showformat='${Version}' --show $package } | complete
        if $query_complete.exit_code == 0 {
                let version = $query_complete.stdout
                $"(ansi green_bold)($version)(ansi reset)"
        } else {
            NO_VERSION_INSTALLED
        }
    } else {
        NO_VERSION_INSTALLED
    }

    if ($version | ansi strip ) == "" {
        $"(ansi yellow_bold)?(ansi reset)"
    } else {
        $version
    }
}
def pacstall-fetch-version [] -> string {
    let package: string = $in
    if (cmd-exist 'pacstall') {
        let qi_complete = do { ^pacstall -Qi $package version} | complete
        if $qi_complete.stderr == "" {
            $"(ansi green_bold)($qi_complete.stdout)(ansi reset)"
        } else {
            NO_VERSION_INSTALLED
        }
    } else {
        NO_VERSION_INSTALLED
    }
    
}

def flatpak-fetch-version [] -> string {
    let package: string = $in
    if (cmd-exist 'flatpak') {
        let info_complete = do { ^flatpak info $package } | complete
        if $info_complete.stderr == "" {
            let version = $info_complete.stdout | lines | collect { |x| $x.7 | parse --regex '\s*Version: (?P<version>.*)' | collect { |y| $y.version.0 }}
            $"(ansi green_bold)($version)(ansi reset)"
        } else {
            NO_VERSION_INSTALLED
        }
    } else {
        NO_VERSION_INSTALLED
    }
}

def snap-fetch-version [] -> string {
    let package: string = $in
    if (cmd-exist 'snap') {
        let list_complete = do { ^snap list $package } | complete
        if $list_complete.stderr == "" {
            let version = $list_complete.stdout | lines | skip 1 | collect { |x| $x.0 | split row ' ' | collect { |y| $y.2}}  
            $"(ansi green_bold)($version)(ansi reset)"
        } else {
            NO_VERSION_INSTALLED
        }
    } else {
        NO_VERSION_INSTALLED
    }
}