# Functions like the sync command for pacman
# Updates all repos that can update their repos
export def main [ ] {
    if (cmd-exist 'nala') {
        ^sudo nala update
    } else {
        ^sudo apt update
    }
    if (cmd-exist 'flatpak') {
        ^flatpak update --appstream
    }
}