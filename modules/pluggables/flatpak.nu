use "/usr/share/rhino-pkg/modules/lib/" [cmd]

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

export def search [input: string, --description] -> table {
    # Description here is a dummy flag, because flatpak searches by both name and description with no way
    # to change that afaik.
    if (cmd exists "flatpak") {
        ^flatpak search $input --columns=application:f
            | lines
            | wrap 'pkg'
            | insert provider 'flatpak'
            | merge (^flatpak search $input --columns=description:f
                | lines
                | wrap 'desc')
    } else {
        []
    }
}

export def upgrade [--promptless] {
    if (cmd exists "flatpak") {
        if $promptless {
            ^flatpak update -y
        } else {
            ^flatpak update
        }
    }
}
