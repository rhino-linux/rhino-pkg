use "/usr/share/rhino-pkg/modules/lib/screen.nu" [clearscr]
use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [print-color]

export def search-pkgs [
    description: bool
    rest: string
] -> table {
    use "/usr/share/rhino-pkg/modules/pluggables/" [pacstall flatpak apt snap]
    print "Searching pacstall..."
    let pac_results = (pacstall search $rest $description)
    clearscr
    print "Searching flatpak..."
    let flatpak_results = (flatpak search $rest $description)
    clearscr
    print "Searching apt..."
    let apt_results = (apt search $rest $description)
    print "Searching snap..."
    let snap_results = (snap search $rest $description)
    clearscr
    let total = $snap_results | append $flatpak_results | append $apt_results | append $pac_results
    mut idx = 0
    for bla in $total {
        let le_color = (print-color $bla.provider)
        print $"[($le_color)($idx)(ansi reset)]: ($bla.pkg) \(($le_color)($bla.provider)(ansi reset)\)"
        $idx += 1
    }
    # Just because someone else might need the table.
    return $total
}

export def search-local-pkgs [search: string] -> table {
    use "/usr/share/rhino-pkg/modules/pluggables/" [pacstall flatpak apt snap]
    print "Searching pacstall..."
    let pac_results = (pacstall list-installed $search)
    clearscr
    print "Searching flatpak..."
    let flatpak_results = (flatpak list-installed $search)
    clearscr
    print "Searching apt..."
    let apt_results = (apt list-installed $search)
    print "Searching snap..."
    let snap_results = (snap list-installed $search)
    clearscr
    let total = $snap_results | append $flatpak_results | append $apt_results | append $pac_results
    mut idx = 0
    for bla in $total {
        let le_color = (print-color $bla.provider)
        print $"[($le_color)($idx)(ansi reset)]: ($bla.pkg) ~ ($bla.version | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') \(($le_color)($bla.provider)(ansi reset)\)"
        $idx += 1
    }
    # Just because someone else might need the table.
    return $total
}
