use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists]

export def list-installed [search: string] {
    if (exists "flatpak") {
        ^flatpak list --columns=application:f,version:f --app
            | lines
            | uniq
            | parse "{pkg}\t{version}"
            | where pkg =~ $search
            | insert provider "flatpak"
    }
}

export def search [input: string, description: bool] -> table {
    # Description here is a dummy flag, because flatpak searches by both name and description with no way
    # to change that afaik.
    if (exists "flatpak") {
        ^flatpak search $input --columns=application:f,remotes:f
            | lines
            | parse -r '^([\w.-]+)\s+(\w+)$'
            | rename pkg remote
            | insert provider 'flatpak'
            | merge (^flatpak search $input --columns=description:f
                | lines
                | wrap 'desc')
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
