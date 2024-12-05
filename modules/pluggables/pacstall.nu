use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists]

export def list-installed [search: string] {
    # I'm using par-each because it's wayyy quicker and I can just sort the stuff afterwards
    if (exists "pacstall") {
        ^pacstall -L
            | lines
            | par-each {
                |pkg| {
                    "pkg": $pkg,
                    "version": (^pacstall -Ci $pkg version)
                }
            } | sort-by pkg
            | where pkg =~ $search
            | insert provider "pacstall"
    }
}

export def search [input: string, description: bool] -> table {
    if (exists "pacstall") {
        if $description {
            # We are searching for something in description
            ^pacstall -Sd $input
                | ansi strip
                | lines
                | parse "{pkg} - {desc} @ {repo}"
                | insert provider 'pacstall'
        } else {
            # Searching by name
            ^pacstall -S $input
                | ansi strip
                | lines
                | parse "{pkg} @ {repo}"
                | insert desc ''
                | insert provider 'pacstall'
        }
    } else {
        []
    }
}

export def upgrade [promptless: bool] {
    if (exists "pacstall") {
        if $promptless {
            ^pacstall -PUp
        } else {
            ^pacstall -Up
        }
    }
}
