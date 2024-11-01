export def exists [cmd: string] -> bool {
    ((which $cmd | length) > 0)
}

# Return color based off of package manager
export def print-color [type: string] {
    match $type {
        "pacstall" => (ansi yellow_bold)
        "apt" => (ansi green_bold)
        "flatpak" => (ansi cyan_bold)
        "snap" => (ansi red_bold)
        _ => (ansi grey_bold)
    }
}

export def prompt [ask: string, index: int] -> int {
    let input = (input $"($ask) [0-($index)]: ")
    if ($input | is-empty) {
        0
    } else {
        $input
    }
}
