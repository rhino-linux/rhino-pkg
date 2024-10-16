use "/usr/share/rhino-pkg/modules/lib/" [cmd]

export def list-installed [] {
    # I'm using par-each because it's wayyy quicker and I can just sort the stuff afterwards
    ^pacstall -L
        | lines
        | par-each {
            |pkg| {
                "name": $pkg,
                "version": (^pacstall -Ci $pkg version)
            }
        } | sort-by name
}

export def search [input: string, description: bool] -> table {
    if (cmd exists "pacstall") {
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

export def upgrade [--promptless] {
    if (cmd exists "pacstall") {
        if $promptless {
            ^pacstall -PUp
        } else {
            ^pacstall -Up
        }
    }
}
