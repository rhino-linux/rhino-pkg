export def exists [cmd: string] : nothing -> bool {
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

export def prompt [ask: string, pkgs: list] : nothing -> table {
    let input = (input $"($ask) [0-(($pkgs | length) - 1)]: ")
    if ($input | is-empty) {
        []
    } else {
        let parsed = ($input
            | split row ' '
            | find --regex "[0-9]+" --regex "^[0-9]+"
            | into int
            | filter {|key| $key in 0..<($pkgs | length)}
        )
        if ($parsed | is-empty) {
            tprint -e "No valid inputs given"
            exit 1
        }
        $pkgs
            | enumerate
            | where $parsed has index
            | flatten
    }
}

export def install-pkg [
        pkg: record,
        promptless: bool
    ] {
    match $pkg.provider {
        "pacstall" => {
            pacstall install $pkg $promptless
        }
        "apt" => {
            apt install $pkg.pkg $promptless
        }
        "flatpak" => {
            flatpak install $pkg $promptless
        }
        "snap" => {
            snap install $pkg
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
                ^pacstall -PR $pkg.pkg
            } else {
                ^pacstall -R $pkg.pkg
            }
        }
        "apt" => {
            if $promptless {
                ^sudo apt-get remove $pkg.pkg -y
            } else {
                ^sudo apt-get remove $pkg.pkg
            }
        }
        "flatpak" => {
            if $promptless {
                ^flatpak remove $pkg.pkg -y
            } else {
                ^flatpak remove $pkg.pkg
            }
        }
        "snap" => {
            ^sudo snap remove $pkg.pkg --purge
        }
    }
}

export def cleanup-pkg [promptless: bool] {
    if $promptless {
        if (exists "apt") {
            ^sudo apt-get --fix-broken install
            ^sudo apt-get autoremove -y
        }
        if (exists "flatpak") {
            ^sudo flatpak repair
            ^sudo flatpak uninstall --unused -y
        }
    } else {
        if (exists "apt") {
            ^sudo apt-get --fix-broken install
            ^sudo apt-get autoremove
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
