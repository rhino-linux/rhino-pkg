use "/usr/share/rhino-pkg/modules/lib/cmd.nu" [exists]

export def list-installed [search: string] {
    if (exists "aptitude") {
        LANG=C ^aptitude search $"~i($search) !?section\(Pacstall\)" -F '%p|%v'
            | lines
            | parse "{pkg}|{version}"
            | insert provider "apt"
            # Reject packages that exist in pacstall (hence should be handled by pacstall).
            | filter {|pkg| $pkg.pkg not-in (get-pacstall-debs) }
    }
}

def get-pacstall-debs [] : nothing -> list<string> {
    ls /var/lib/pacstall/metadata
        | get name
        | where (str ends-with '-deb')
        | par-each {
            |file|
            open $file
                | lines
                | find '_gives'
                # We assume that every single -deb package has logged gives.
                | get 0
                # This is somewhat volatile, as it depends on how `declare -p _gives` is formatted.
                | parse '_gives="{apt_name}"'
        } | flatten
          | values
          # Pull out the list.
          | get 0
}

export def search [input: string, description: bool] : nothing -> table {
    if (exists "aptitude") {
        if $description {
            # We are searching for something in description
            LANG=C ^aptitude search --quiet --disable-columns $"\(?name\(($input)\) | ?description\(($input)\)\) ?architecture\(native\) !?section\(Pacstall\)" -F "%p|%d"
                | lines
                | parse "{pkg}|{desc}"
                | insert provider 'apt'
                | where (($it.pkg | str downcase) =~ ($input | str downcase)) or (($it.desc | str downcase) =~ ($input | str downcase))
                | filter {|pkg| $pkg.pkg not-in (get-pacstall-debs) }
        } else {
            LANG=C ^aptitude search --quiet --disable-columns $"?name\(($input)\) ?architecture\(native\) !?section\(Pacstall\)" -F "%p"
                | lines
                | parse "{pkg}"
                | insert desc ''
                | insert provider 'apt'
                | filter {|pkg| $pkg.pkg not-in (get-pacstall-debs) }
        }
    } else {
        error make -u { msg: (_ "`aptitude` not installed.") }
        exit 1
    }
}

export def upgrade [promptless: bool] {
    if (exists "nala") {
        if $promptless {
            ^sudo nala upgrade -y --full --no-autoremove -o Acquire::AllowReleaseInfoChange="true"
        } else {
            ^sudo nala upgrade --full --no-autoremove -o Acquire::AllowReleaseInfoChange="true"
        }
    } else if (exists "apt") {
        if $promptless {
            ^sudo apt update --allow-releaseinfo-change -y
            ^sudo apt upgrade -y
        } else {
            ^sudo apt update --allow-releaseinfo-change
            ^sudo apt upgrade
        }
    }
}

export def install [pkg: string, promptless: bool] {
    if (exists "nala") {
        if $promptless {
            ^sudo nala install $pkg -y
        } else {
            ^sudo nala install $pkg
        }
    } else if (exists "apt") {
        if $promptless {
            ^sudo apt install $pkg -y
        } else {
            ^sudo apt install $pkg
        }
    }
}
