use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists]

export def list-installed [search: string] {
    if (exists "flatpak") {
        try { ^flatpak list --columns=application:f,version:f --app
            | lines
            | uniq
            | parse "{pkg}\t{version}"
            | where ($it.pkg | str downcase) =~ ($search | str downcase)
            | insert provider "flatpak" } catch { [] }
    }
}

export def search [input: string, description: bool] : nothing -> table {
    if (exists "flatpak") {
        if $description {
            ^sudo flatpak search $input --columns=application:f,remotes:f,description:f
                | lines
                | where $it != "No matches found"
                | parse -r '^([\w.-]+)\s+(\w+)\s+(.*)$'
                | rename pkg remote desc
                | insert provider 'flatpak'
        } else {
            ^sudo flatpak search $input --columns=application:f,remotes:f
                | lines
                | where $it != "No matches found"
                | parse -r '^([\w.-]+)\s+(\w+)$'
                | rename pkg remote
                | where ($it.pkg | str downcase) =~ ($input | str downcase)
                | insert provider 'flatpak'
        }
    } else {
        []
    }
}

export def upgrade [promptless: bool] {
    if (exists "flatpak") {
        if $promptless {
            ^sudo flatpak update -y
        } else {
            ^sudo flatpak update
        }
    }
}

export def install [pkg: string, remote: string, promptless: bool] {
    if (exists "flatpak") {
        if $promptless {
            ^sudo flatpak install $remote $pkg -y
        } else {
            ^sudo flatpak install $remote $pkg
        }
    }
}
