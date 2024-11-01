use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists]

export def list-installed [] {
    ^dpkg-query -W
        | lines
        | parse "{pkg}\t{version}"
}

export def search [input: string, description: bool] -> table {
    if (exists "aptitude") {
        if $description {
            # We are searching for something in description
            ^aptitude search --quiet --disable-columns '?name(visual) | ?description(visual) ?architecture(native) !?section(Pacstall)' -F "%p|%d"
                | lines
                | parse "{pkg}|{desc}"
                | insert provider 'apt'
        } else {
            ^aptitude search --quiet --disable-columns '?name(visual) ?architecture(native) !?section(Pacstall)' -F "%p"
                | lines
                | parse "{pkg}"
                | insert desc ''
                | insert provider 'apt'
        }
    } else {
        []
    }
}

export def upgrade [--promptless] {
    if (exists "apt") {
        if $promptless {
            ^sudo apt update -y
            ^sudo apt upgrade -y
        } else {
            ^sudo apt update
            ^sudo apt upgrade
        }
    }
}
