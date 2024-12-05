use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists]

export def list-installed [search: string] {
    if (exists "snap") {
        ^snap list
            | detect columns
            | reject Rev Tracking Publisher Notes
            | rename --column { Name: pkg }
            | rename --column { Version: version }
            | where pkg =~ $search
            | insert provider "snap"
    }
}

export def search [input: string, description: bool] -> table {
    if (exists "snap") {
        ^snap search $input
            | detect columns --guess
            | reject Publisher Version
            | rename --column { Name: pkg }
            | rename --column { Summary: desc }
            | insert provider 'snap'
    } else {
        []
    }
}

export def upgrade [promptless: bool] {
    if (exists "snap") {
        ^sudo snap refresh
    }
}
