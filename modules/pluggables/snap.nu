use "/usr/share/rhino-pkg/modules/lib/" [cmd]

# TODO: Make this snap
export def list-installed [] {
    ^flatpak list --app --columns=application:f
        | lines
        | uniq
        | par-each {
            |pkg| {
                "name": $pkg,
                "version": (^flatpak info $pkg
                    | grep Version
                    | str trim
                    | parse "{bla}: {version}"
                    | reject bla).version.0
            }
        }
}

export def search [input: string, description: bool] -> table {
    if (cmd exists "snap") {
        ^snap search $input
            | detect columns
            | get Name
            | wrap 'package'
            | insert description ''
            | insert provider 'snap'
    } else {
        []
    }
}

# TODO: Make this snap
export def upgrade [--promptless] {
    if (cmd exists "flatpak") {
        if $promptless {
            ^flatpak update -y
        } else {
            ^flatpak update
        }
    }
}
