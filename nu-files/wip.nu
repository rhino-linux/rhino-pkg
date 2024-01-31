def all-installed-programs [] {
    let apt_programs = if (cmd-exist 'apt') {
        ^apt list --installed | lines | parse "{package}/{junk1} {version} {junk2}" | select package version
    } else {
        []
    }
    let pacstall_programs = if (cmd-exist 'pacstall') {

    }    
}



def search-installed-apt [input: string, desc: bool] -> table {
    if (cmd-exist 'apt') {
        ^apt list --installed | lines | parse "{package}/{junk1} {version} {junk2}" | select package version | filter {|pkg| $pkg.package | str contains $input}
    } else {
        []
    }
}

def link-install [input: string] -> {

}

def path-install [input: string] {

}

def deb-install [] {
    let path: string = $in
    if (cmd-exist 'apt') {
        ^sudo apt install $path
    } else {
        # should be impossible
    }
}

def flatpakref-install [] {
    let path: string = $in
    if (cmd-exist 'flatpak') {
        ^sudo flatpak install --from $path
    } else {
        # cannot install flatpaks because flatpak is not installed
    }

}

def pacscript-install [] {
    let path: string = $in
    if (cmd-exist 'pacstall') {
        ^sudo pacstall -I $path
    } else {
        # cannot install pacscript because Pacstall is not installed
    }
}




#def test-install-apt [] -> table {
#    let table_in: table = $in
#    mut repo_table: table = ($table_in | insert installed $"(ansi red)\(none\)(ansi reset)")
#    let installed_pkgs = ^apt list --installed | lines | parse "{name}/{remainder}"
#    let repo_table_length = $table_in | length
#    let installed_pkgs_length = $installed_pkgs | length
#    
#    for i: int in 0..$repo_table_length {
#        let package = ($repo_table | select $i ).package.0
#        
#        for j in 0..$installed_pkgs_length { 
#            let $inst_pkg = ($installed_pkgs | select $j).name
#            #print $inst_pkg
#            if $package == $inst_pkg { 
#            let policy_table = ^apt-cache policy $package | detect columns --skip 1 --no-headers
#            $repo_table.$i.installed = $"(ansi green)\(($policy_table.column1.0)\)(ansi reset)"
#            break
#        } } 
#    }

#    repo_table

#}




def search-installed-pacstall [input: string] -> table {
    if (cmd-exist 'pacstall') {
        ^pacstall -L | ansi strip | lines | filter  {|pkg| $pkg.package | str contains $input}
    } else {
        []
    }
}


def search-installed-flatpak [input: string, desc: bool] -> table {
    if (cmd-exist 'flatpak') {

    } else {
        []
    }
}



#def search-zap [search_term: string] {
#   if (cmd-exist 'zap') {
#    let all_zap_pkgs = ( http get "https://g.srev.in/get-appimage/index.min.json" | select name summary | rename package description | insert provider zap) 
#    $all_zap_pkgs | prune-search-table $search_term 
#   } else { [] }
#}





def info [ ] {
    let input: table = $in
    let user_input_ints =  user-package-selection $input "info"
}
