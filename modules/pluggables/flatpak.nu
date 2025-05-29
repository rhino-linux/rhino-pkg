use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists]

export def list-installed [search: string] {
    if (exists "flatpak") {
        try { ^flatpak list --columns=application:f,version:f --app
            | lines
            | uniq
            | parse "{pkg}\t{version}"
            | where pkg =~ $search
            | insert provider "flatpak" } catch { [] }
    }
}

export def search [input: string, description: bool] : nothing -> table {
    if (exists "flatpak") {
        if $description {
            ^flatpak search $input --columns=application:f,remotes:f,description:f
                | lines
                | where $it != "No matches found"
                | parse -r '^([\w.-]+)\s+(\w+)\s+(.*)$'
                | rename pkg remote desc
                | insert provider 'flatpak'
        } else {
            ^flatpak search $input --columns=application:f,remotes:f
                | lines
                | where $it != "No matches found"
                | parse -r '^([\w.-]+)\s+(\w+)$'
                | rename pkg remote
                | where pkg =~ $input
                | insert provider 'flatpak'
        }
    } else {
        []
    }
}

export def upgrade [promptless: bool] {
    if (exists "flatpak") {
        if $promptless {
            ^flatpak update -y
        } else {
            ^flatpak update
        }
    }
}

export def install [pkg: string, remote: string, promptless: bool] {
    if (exists "flatpak") {
        if $promptless {
            ^flatpak install $remote $pkg -y
        } else {
            ^flatpak install $remote $pkg
        }
    }
}
