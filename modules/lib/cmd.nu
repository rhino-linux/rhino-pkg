export def exists [cmd: string] -> bool {
    ((which $cmd | length) > 0)
}

# Return color based off of package manager
export def print-color [type: string] {
    match $type {
        "pacstall" => (ansi yellow_bold)
        "apt" => (ansi green_bold)
        "flatpak" => (ansi cyan_bold)
        "snap" => (ansi red_bold)
        _ => (ansi grey_bold)
    }
}

export def prompt [ask: string, pkgs: table] -> table {
    let input = (input $"($ask) [0-($pkgs | length)]: ")
    if ($input | is-empty) {
        [($pkgs | enumerate).0.item]
    } else {
        let parsed = ($input
            | split row ' '
            | find --regex "[0-9]+" --regex "^[0-9]+"
            | into int
            | filter {|key| $key in 0..<($pkgs | length)}
        )
        if ($parsed | is-empty) {
            print -e "No valid inputs given"
            exit 1
        }
        $pkgs
            | enumerate
            | where index in $parsed
            | flatten
    }
}

export def install-pkg [
        pkg: record,
        promptless: bool
    ] {
    match $pkg.provider {
        "pacstall" => {
            if $promptless {
                (^pacstall -PI $"($pkg.pkg)@($pkg.repo)")
            } else {
                (^pacstall -I $"($pkg.pkg)@($pkg.repo)")
            }
        }
        "apt" => {
            if $promptless {
                (^sudo apt install $pkg.pkg -y)
            } else {
                (^sudo apt install $pkg.pkg)
            }
        }
        "flatpak" => {
            if $promptless {
                (^flatpak install $pkg.remote $pkg.pkg -y)
            } else {
                (^flatpak install $pkg.remote $pkg.pkg)
            }
        }
        # So snap is weird because some packages need classic installation
        # ref: [https://github.com/rhino-linux/rhino-pkg/issues/46].
        # But on the plus side it doesn't have the ability for -y.
        "snap" => {
            if ($pkg.Notes == "classic") {
                (^sudo snap install --classic $pkg.pkg)
            } else {
                (^sudo snap install $pkg.pkg)
            }
        }
    }
}

export def remove-pkg [
        pkg: record,
        promptless: bool
    ] {
    match $pkg.provider {
        "pacstall" => {
            if $promptless {
                (^pacstall -PR $pkg.pkg)
            } else {
                (^pacstall -R $pkg.pkg)
            }
        }
        "apt" => {
            if $promptless {
                (^sudo apt remove $pkg.pkg -y)
            } else {
                (^sudo apt remove $pkg.pkg)
            }
        }
        "flatpak" => {
            if $promptless {
                (^flatpak remove $pkg.pkg -y)
            } else {
                (^flatpak remove $pkg.pkg)
            }
        }
        "snap" => {
            (^sudo snap remove $pkg.pkg --purge)
        }
    }
}

export def cleanup-pkg [promptless: bool] {
    if $promptless {
        if (exists "apt") {
            ^sudo apt --fix-broken install
            ^sudo apt apt-remove -y
        }
        if (exists "flatpak") {
            ^sudo flatpak repair
            ^sudo flatpak uninstall --unused -y
        }
    } else {
        if (exists "apt") {
            ^sudo apt --fix-broken install
            ^sudo apt apt-remove
        }
        if (exists "flatpak") {
            ^sudo flatpak repair
            ^sudo flatpak uninstall --unused
        }
    }
    if (exists "snap") {
        ^snap list --all
            | detect columns
            | where Notes =~ "disabled"
            | each {|pkg| ^sudo snap remove $pkg.Name --revision=($pkg.Version)}
    }
}
