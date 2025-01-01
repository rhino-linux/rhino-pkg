use "/usr/share/rhino-pkg/modules/lib/screen.nu" [clearscr]
use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [print-color]

export def search-pkgs [
    description: bool
    rest: string
] : nothing -> table {
    use "/usr/share/rhino-pkg/modules/pluggables/" [pacstall flatpak apt snap]
    tprint "Searching Pacstall…"
    let pac_results = (pacstall search $rest $description)
    clearscr
    tprint "Searching flatpak…"
    let flatpak_results = (flatpak search $rest $description)
    clearscr
    tprint "Searching apt…"
    let apt_results = (apt search $rest $description)
    tprint "Searching snap…"
    let snap_results = (snap search $rest $description)
    clearscr
    let total = $snap_results | append $flatpak_results | append $apt_results | append $pac_results
    mut idx = 0
    for bla in $total {
        let le_color = (print-color $bla.provider)
        tprint "[{idx}]: {pkg} ({provider})" { idx: $"($le_color)($idx)(ansi reset)", pkg: $bla.pkg, provider: $"($le_color)($bla.provider)(ansi reset)" }
        $idx += 1
    }
    # Just because someone else might need the table.
    return $total
}

export def search-local-pkgs [search: string] : nothing -> table {
    use "/usr/share/rhino-pkg/modules/pluggables/" [pacstall flatpak apt snap]
    tprint "Searching Pacstall…"
    let pac_results = (pacstall list-installed $search)
    clearscr
    print "Searching flatpak…"
    let flatpak_results = (flatpak list-installed $search)
    clearscr
    tprint "Searching apt…"
    let apt_results = (apt list-installed $search)
    tprint "Searching snap…"
    let snap_results = (snap list-installed $search)
    clearscr
    let total = $snap_results | append $flatpak_results | append $apt_results | append $pac_results
    mut idx = 0
    for bla in $total {
        let le_color = (print-color $bla.provider)
        print $"[($le_color)($idx)(ansi reset)]: ($bla.pkg) ~ (ansi defb)($bla.version)(ansi reset) \(($le_color)($bla.provider)(ansi reset)\)"
        $idx += 1
    }
    # Just because someone else might need the table.
    return $total
}
