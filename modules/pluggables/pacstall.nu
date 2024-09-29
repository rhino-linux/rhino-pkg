export def pacstall-list-installed [] {
    # I'm using par-each because it's wayyy quicker and I can just sort the stuff afterwards
    ^pacstall -L | lines | par-each { |pkg| { "name": $pkg, "version": (^pacstall -Ci $pkg version) } } | sort-by name
}

export def pacstall-search [input?: string, --description] -> table {
    if $input == null {
        if $description {
            # Search with description for everything
            ^pacstall -Sd ':pkgbase' | ansi strip | lines | parse "{pkg} - {desc} @ {repo}" | insert provider 'pacstall'
        } else {
            # Search everything
            ^pacstall -S '$' | ansi strip | lines | parse "{pkg} @ {repo}" | insert desc '' | insert provider 'pacstall'
        }
    } else {
        if $description {
            # We are searching for something in description
            ^pacstall -Sd $input | ansi strip | lines | parse "{pkg} - {desc} @ {repo}" | insert provider 'pacstall'
        } else {
            # Searching by name
            ^pacstall -S $input | ansi strip | lines | parse "{pkg} @ {repo}" | insert desc '' | insert provider 'pacstall'

        }
    }
}

export def pacstall-upgrade [--promptless] {
    if $promptless {
        ^pacstall -PUp
    } else {
        ^pacstall -Up
    }
}
