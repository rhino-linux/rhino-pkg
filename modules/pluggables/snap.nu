use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists]

export def list-installed [search: string] {
    if (exists "snap") {
        try { ^snap list
            | detect columns
            | reject Rev Tracking Publisher Notes
            | rename --column { Name: pkg }
            | rename --column { Version: version }
            | where pkg =~ $search
            | insert provider "snap" } catch { [] }
    }
}

export def search [input: string, description: bool] : nothing -> table {
    if (exists "snap") {
        let raw = (^snap search $input)
        if ($raw | is-empty) {
            []
        } else {
            $raw
                | detect columns --guess
                | reject Publisher Version
                | rename --column { Name: pkg }
                | rename --column { Summary: desc }
                | insert provider 'snap'
        }
    } else {
        []
    }
}

export def upgrade [promptless: bool] {
    if (exists "snap") {
        ^sudo snap refresh
    }
}

# So snap is weird because some packages need classic installation
# ref: [https://github.com/rhino-linux/rhino-pkg/issues/46].
# But on the plus side it doesn't have the ability for -y.
export def install [pkg: record] {
    if (exists "snap") {
        if ($pkg.Notes == "classic") {
            ^sudo snap install --classic $pkg.pkg
        } else {
            ^sudo snap install $pkg.pkg
        }
    }
}
