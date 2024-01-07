export def main [promptless: bool = false] {
    if (cmd-exist 'nala') {
        ^sudo nala install --fix-broken
        if $promptless {
            ^sudo nala autoremove -y
        } else {
            ^sudo nala autoremove
        }
    } else {
        ^sudo apt --fix-broken install
        if $promptless { ^sudo apt auto-remove -y } else { ^sudo apt auto-remove }
    }
    if (cmd-exist 'flatpak') {
        ^sudo flatpak repair
        if $promptless { ^sudo flatpak uninstall --unused -y } else { ^sudo flatpak uninstall --unused }
    }
    if (cmd-exist 'snap') {
        let snaps = (^snap list --all | detect columns)
        for $pkg in $snaps {
            if ($pkg.Notes) =~ "disabled" {
                ^sudo snap remove $pkg.Name --revision=$pkg.Rev
            }
        }
    }
}