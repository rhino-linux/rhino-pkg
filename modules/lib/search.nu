use "/usr/share/rhino-pkg/modules/lib/screen.nu" [clearscr]
use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists print-color]

export def search-pkgs [
    description: bool
    rest: string
] : nothing -> table {
    use "/usr/share/rhino-pkg/modules/pluggables/" [apt pacstall flatpak snap]
    if (exists "flatpak") {
        ^sudo -v
    }
    tprint "Searching APT…"
    let apt_results = (apt search $rest $description err> /dev/null)
    clearscr
    tprint "Searching Pacstall…"
    let pac_results = (pacstall search $rest $description err> /dev/null)
    clearscr
    tprint "Searching Flatpak…"
    let flatpak_results = (flatpak search $rest $description err> /dev/null)
    clearscr
    tprint "Searching Snap…"
    let snap_results = (snap search $rest $description err> /dev/null)
    clearscr
    let total = $apt_results
        | append $pac_results
        | append $flatpak_results
        | append $snap_results
        | sort-by pkg
        | enumerate
        | each { |row|
            let le_color = (print-color $row.item.provider)
            {
                index: $"($le_color)($row.index)(ansi reset)",
                pkg: $"(ansi attr_normal)($row.item.pkg)(ansi reset)",
                provider: $"($le_color)($row.item.provider)(ansi reset)",
                remote: ($row.item | get -o remote | default ""),
                repo: ($row.item | get -o repo | default ""),
                desc: ($row.item | get -o desc | default ""),
                notes: ($row.item | get -o Notes | default "")
            }
        }
    return $total
}

export def search-local-pkgs [search: string] : nothing -> table {
    use "/usr/share/rhino-pkg/modules/pluggables/" [apt pacstall flatpak snap]
    tprint "Searching APT…"
    let apt_results = (apt list-installed $search err> /dev/null)
    clearscr
    tprint "Searching Pacstall…"
    let pac_results = (pacstall list-installed $search err> /dev/null)
    clearscr
    tprint "Searching Flatpak…"
    let flatpak_results = (flatpak list-installed $search err> /dev/null)
    clearscr
    tprint "Searching Snap…"
    let snap_results = (snap list-installed $search err> /dev/null)
    clearscr
    let total = $apt_results
        | append $pac_results
        | append $flatpak_results
        | append $snap_results
        | sort-by pkg
        | enumerate
        | each { |row|
            let le_color = (print-color $row.item.provider)
            {
                index: $"($le_color)($row.index)(ansi reset)",
                pkg: $"(ansi attr_normal)($row.item.pkg)(ansi reset)",
                provider: $"($le_color)($row.item.provider)(ansi reset)",
                version: $"(ansi white_bold)($row.item.version)(ansi reset)",
                remote: ($row.item | get -o remote | default ""),
                repo: ($row.item | get -o repo | default ""),
                desc: ($row.item | get -o desc | default ""),
                notes: ($row.item | get -o Notes | default "")
            }
        }
    return $total
}
