use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists]

export def list-installed [search: string] {
    # I'm using par-each because it's wayyy quicker and I can just sort the stuff afterwards
    if (exists "pacstall") {
        try { ^pacstall -L
            | lines
            | par-each {
                |pkg| {
                    "pkg": $pkg,
                    "version": (^pacstall -Ci $pkg pacversion)
                }
            } | sort-by pkg
            | where ($it.pkg | str downcase) =~ ($search | str downcase)
            | insert provider "pacstall" } catch { [] }
    }
}

export def search [input: string, description: bool] : nothing -> table {
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

export def install [pkg: string, repo: string, promptless: bool] {
    if (exists "pacstall") {
        if $promptless {
            ^pacstall -PI $"($pkg)@($repo)"
        } else {
            ^pacstall -I $"($pkg)@($repo)"
        }
    }
}
