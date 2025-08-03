export def exists [cmd: string] : nothing -> bool {
    ((which $cmd | length) > 0)
}

export def exists-apt [pkg: string] : nothing -> bool {
    (
        (^dpkg-query -s $pkg err> /dev/null
            | complete
            | get exit_code
        ) == 0
    )
}

# Return color based off of package manager
export def print-color [type: string] {
    match $type {
        "apt" => (ansi blue_bold)
        "pacstall" => (ansi yellow_bold)
        "flatpak" => (ansi cyan_bold)
        "snap" => (ansi red_bold)
        _ => (ansi grey_bold)
    }
}

export def prompt [ask: string, pkgs: list] : nothing -> table {
    if (($pkgs | length) == 1) {
        $pkgs
            | enumerate
            | where index == 0
            | flatten
    } else {
        let input = (
            try {
                input $"($ask) (ansi wb)[(ansi reset)(ansi p) 0(ansi reset) … (ansi p)(($pkgs | length) - 1)(ansi reset) or (ansi r)N(ansi wb) ](ansi reset): "
            }
        )
        if ($input | is-empty) {
            tprint -e "No valid inputs given!"
            exit 1
        }
        let parsed = ($input
            | split row ' '
            | find --regex "[0-9]+" --regex "^[0-9]+"
            | into int
            | where {|key| $key in 0..<($pkgs | length)}
        )
        if ($parsed | is-empty) {
            tprint -e "No valid inputs given!"
            exit 1
        }
        $pkgs
            | enumerate
            | where index in $parsed
            | flatten
    }
}

export def remove-pkg [
        pkg: string,
        provider: string,
        promptless: bool
    ] {
    match $provider {
        "apt" => {
            if (exists "nala") {
                if $promptless {
                    ^sudo nala remove $pkg -y
                } else {
                    ^sudo nala remove $pkg
                }
            } else if (exists "apt") {
                if $promptless {
                    ^sudo apt-get remove $pkg -y
                } else {
                    ^sudo apt-get remove $pkg
                }
            }
        }
        "pacstall" => {
            if $promptless {
                ^pacstall -PR $pkg
            } else {
                ^pacstall -R $pkg
            }
        }
        "flatpak" => {
            if $promptless {
                ^sudo flatpak remove $pkg -y
            } else {
                ^sudo flatpak remove $pkg
            }
        }
        "snap" => {
            ^sudo snap remove $pkg --purge
        }
    }
}

export def cleanup-pkg [promptless: bool] {
    if $promptless {
        if (exists "nala") {
            ^sudo nala install --fix-broken
            ^sudo nala autoremove -y
        } else if (exists "apt") {
            ^sudo apt-get --fix-broken install
            ^sudo apt-get autoremove -y
        }
        if (exists "flatpak") {
            ^sudo flatpak repair
            ^sudo flatpak uninstall --unused -y
        }
    } else {
        if (exists "nala") {
            ^sudo nala install --fix-broken
            ^sudo nala autoremove
        } else if (exists "apt") {
            ^sudo apt-get --fix-broken install
            ^sudo apt-get autoremove
        }
        if (exists "flatpak") {
            ^sudo flatpak repair
            ^sudo flatpak uninstall --unused
        }
    }
    if (exists "snap") {
        for $pkg in (^snap list --all
            | detect columns
            | where Notes =~ "disabled") {
                ^sudo snap remove $pkg.Name --revision=($pkg.Version)
        }
    }
}

export def repo-sync [] {
    if (exists "nala") {
        try {
            ^sudo nala update -o Acquire::AllowReleaseInfoChange="true"
        }
    } else if (exists "apt") {
        ^sudo apt update --allow-releaseinfo-change
    }
    if (exists "pacstall") {
        if not (exists-apt "pacstall") {
            ^pacstall -U
        }
        # repo sync to be added in radiance
    }
    if (exists "flatpak") {
        ^sudo flatpak update --appstream
    }
    # snap is evil and just syncs in the background
}
