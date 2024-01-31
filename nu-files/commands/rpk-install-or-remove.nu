use "../helper-scripts/" [user-package-selection, translation-dir-path]

export def main [install: bool = true] {
    let input: table = $in
    let user_input_ints = user-package-selection $input (if $install {"install"} else { "remove" })

    $user_input_ints | each { |index|
        let pkg = ($input | get $index | get package)
        let provider = ($input | get $index | get provider)
        
        
        #print $"Selecting '(ansi purple_bold)($pkg)(ansi reset)' from package manager '(ansi purple_bold)($provider)(ansi reset)'"
        
        if $install {
            translation-dir-path | translate install-select {package: $pkg, manager: $provider, color: "magenta" } | print
        } else {
            translation-dir-path | translate remove-select {package: $pkg, manager: $provider, color: "magenta" } | print
        }


        let r_u_sure = translation-dir-path| translate ask.sure 
        let sure = (input --numchar 1 $"($r_u_sure) ")
        
        let no: bool = (($sure != "Y") and ($sure != "y"))
        # let sure = (input $"Are you sure? \((ansi green_bold)y(ansi reset)/(ansi red_bold)N(ansi reset)\) ")
        if $no {
            translation-dir-path | translate skipping {package: $pkg, manager: $provider, color: "magenta"} | print
        } else {

            if $install {
                match ($provider) {
                    "pacstall" => (^pacstall -I $pkg),
                    "snap" => (^sudo snap install $pkg),
                    "apt" => (^sudo apt install $pkg -y),
                    "flatpak" => (^sudo flatpak install $pkg -y),
                    "zap" =>    (^sudo zap install $pkg -q)
                }
            } else {
                match ($provider) {
                    "pacstall" => (^pacstall -R $pkg),
                    "snap" => (^sudo snap remove $pkg),
                    "apt" => (^sudo apt remove $pkg -y),
                    "flatpak" => (^sudo flatpak remove $pkg -y),
                    "zap" => (^sudo zap remove $pkg -q)
                }
            }
        }
    }
}