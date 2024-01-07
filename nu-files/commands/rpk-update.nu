export def main [promptless: bool = false] {
    
    let r_u_sure = translation-dir-path| translate ask.upgrade 
    let sure: string = (input --numchar 1 $"($r_u_sure)")
    # let sure = (input $"Are you sure you want to update all packages? \((ansi green_bold)y(ansi reset)/(ansi red_bold)N(ansi reset)\) ")
    let no: bool = (($sure != "Y") and ($sure != "y"))
    if $no {
        exit 1
    } 
    
    if (cmd-exist 'nala') {
        if $promptless {
            ^sudo nala upgrade --full --no-autoremove -o Acquire::AllowReleaseInfoChange="true" -y
        } else {
            ^sudo nala upgrade --full --no-autoremove -o Acquire::AllowReleaseInfoChange="true"
        }
    } else {
        ^sudo apt update --allow-releaseinfo-change
        if $promptless { ^sudo apt upgrade -y } else { ^sudo apt upgrade }
    }
    if (cmd-exist 'pacstall') {
        ^pacstall -U
        if $promptless { ^pacstall -PUp } else { ^pacstall -Up }
    }
    if (cmd-exist 'flatpak') {
        if $promptless { ^sudo flatpak update -y } else { ^sudo flatpak update }
    }
    if (cmd-exist 'snap') {
        ^sudo snap refresh
    }
    
}