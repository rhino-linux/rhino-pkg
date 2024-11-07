use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists]

export def list-installed [search: string] {
    if (exists "aptitude") {
        ^aptitude search $"~i($search) !?section\(Pacstall\)" -F '%p|%v'
            | lines
            | parse "{pkg}|{version}"
            | insert provider "apt"
    }
}

export def search [input: string, description: bool] -> table {
    if (exists "aptitude") {
        if $description {
            # We are searching for something in description
            ^aptitude search --quiet --disable-columns $"?name\(($input)\) | ?description\(($input)\) ?architecture\(native\) !?section\(Pacstall\)" -F "%p|%d"
                | lines
                | parse "{pkg}|{desc}"
                | insert provider 'apt'
        } else {
            ^aptitude search --quiet --disable-columns $"?name\(($input)\) ?architecture\(native\) !?section\(Pacstall\)" -F "%p"
                | lines
                | parse "{pkg}"
                | insert desc ''
                | insert provider 'apt'
        }
    } else {
        []
    }
}

export def upgrade [promptless: bool] {
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
