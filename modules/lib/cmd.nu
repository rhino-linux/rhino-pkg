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

export def prompt [ask: string, index: int] -> int {
    let input = (input $"($ask) [0-($index)]: ")
    if ($input | is-empty) {
        0
    } else {
        $input
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
