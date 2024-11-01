use "/usr/share/rhino-pkg/modules/lib/" [cmd]

export def list-installed [] {
    ^snap list
        | detect columns
        | reject Rev Tracking Publisher Notes
        | rename --column { Name: pkg }
        | rename --column { Version: version }
}

export def search [input: string, description: bool] -> table {
    if (cmd exists "snap") {
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

export def upgrade [--promptless] {
    if (cmd exists "snap") {
        ^sudo snap refresh
    }
}
