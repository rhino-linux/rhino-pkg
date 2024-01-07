use '../helper-scripts/' [cmd-exist, fetch-version, single-line-print, add-whitespace-until-string-length, translation-dir-path]

const VERSION_SEARCH_WARN = 200;

def search-apt [input: string, desc: bool] -> table {
    if (cmd-exist 'apt-cache') {
      let first_table =  if $desc == true {
            (^apt-cache search $input | lines | parse "{package} - {description}" | insert provider 'apt') 
        } else {
            (^apt-cache search --names-only $input | lines | parse "{package} - {description}" | insert provider 'apt') 
        } 
        $first_table
    } else { return [] }
}

def search-pacstall [input: string] -> table {
    if (cmd-exist 'pacstall') {
        let pacstall = do { ^pacstall -S $input  } | complete 
        return ($pacstall.stdout | ansi strip | lines | parse "{package} @ {repo}" | reject repo | insert description '' | insert provider 'pacstall')
      #  if ($result | is-empty) {
      #      print -n $"\e[A\e[K"
       # }
    } else { return [] }
}

def search-flatpak [input: string, desc: bool] -> table {
    if (cmd-exist 'flatpak') {
        if $desc == true {
            let flatpak = (^flatpak search $input --columns=application | lines | wrap 'package' | insert provider 'flatpak' | merge (^flatpak search $input --columns=description | lines | wrap 'description')) 
            if ($flatpak.package.0 == "No matches found") { return [] } else { return $flatpak }
        } else {
            let flatpak = (^flatpak search $input --columns=application | lines | wrap 'package' | insert provider 'flatpak' | insert description '') 
            if ($flatpak.package.0 == "No matches found") { return [] } else { return $flatpak }
        }
    } else {print 'flatpak not installed'; return [] }
}

def search-snap [input: string] -> table {
    if (cmd-exist 'snap') {
        return (^snap search $input | detect columns | get Name | wrap 'package' | insert description '' | insert provider 'snap')
    } else { return [] }
}



def prune-search-table [prune_term: string] -> table {
    let input_table: table = $in
    let downcase_prune_term = ($prune_term |str downcase)
    $input_table | filter { |row|    (($row.package | into string | str downcase | str contains $downcase_prune_term) or ($row.description | into string | str downcase | str contains $downcase_prune_term))}
}

export def main [input: string, desc: bool = false, extra_prune_terms: table = []] -> table {
    translation-dir-path | translate searching.apt | print
    # print "Searching apt…"
    let apt = (search-apt $input $desc)
    print -n $"\e[A\e[K"
    # print "Searching Pacstall…"
    translation-dir-path | translate searching.pacstall | print
    let pacstall = (search-pacstall $input)
    print -n $"\e[A\e[K"
    # print "Searching flatpak…"
    translation-dir-path | translate searching.flatpak | print
    let flatpak = (search-flatpak $input $desc)
    print -n $"\e[A\e[K"
    # print "Searching snap…"
    translation-dir-path | translate searching.snap | print
    let snap = (search-snap $input)
    print -n $"\e[A\e[K"
    #print $extra_prune_terms
    mut results =  ($apt | append $pacstall | append $flatpak | append $snap )

    #additional search terms management
    mut search_term: string = $input
    for i in 0..<($extra_prune_terms | length ) {
        let prune_term: string = ($extra_prune_terms | select $i).0
        # prune the results based on other search terms
        $results = ($results | prune-search-table $prune_term)
        # making search terms into one string
        $search_term += " " 
        $search_term += $prune_term
    }


    # print -n $"\e[A\e[K"
    if ($results | is-empty) {
        # print -e $"No packages found matching '($input)'!"
        translation-dir-path | translate none-matching {search: $search_term, color: magenta } | print
        exit 1
    }
    let results_len = $results | length

    (translation-dir-path | translate found-matching {matches: $results_len, search: $search_term, color: magenta} ) + "\n" | print
   # print $"Found packages matching '(ansi purple_bold)($input)(ansi reset)':\n"
    
    mut skip_version_search: bool = false
    if $results_len > $VERSION_SEARCH_WARN {
        let prompt = $"Search resulted in over ($VERSION_SEARCH_WARN) packages. Searching whether the packages are installed may take significant time. Would you like to skip this step? \(Y/n\)"
        let skip = (input --numchar 1 $"($prompt) " | str downcase)
        $skip_version_search = ($skip != "n")
    }
    $results = ($results | insert version '')
    if not $skip_version_search {
        let version_table = ($results | calc-version-numbers)
        $results = ($results | merge $version_table) 
    }
    #preparation for descriptions
    mut longest_package_name_length = 0
    if true {
        #find length of longest package name
        for i in 0..<$results_len {
            if (($results.package | select $i).0 | ansi strip | str length --grapheme-clusters) > $longest_package_name_length {
                $longest_package_name_length = (($results.package | select $i).0 | ansi strip | str length --grapheme-clusters)
            }
        }
    }
    mut longest_version_length = 0
    if not $skip_version_search {
        for i in 0..<$results_len {
            if (($results.version |select $i).0 | ansi strip | str length --grapheme-clusters) > $longest_version_length {
                $longest_version_length = (($results.version | select $i).0 | ansi strip | str length --grapheme-clusters)
            }
        }
    }
    mut count = 0
    # Loop over results
    let result_max_digits: int = ($results_len | into string | str length --grapheme-clusters)
    for $i in $results {
        let style = match $i.provider {
            "pacstall" => $"(ansi yellow_bold)",
            "apt" => $"(ansi green_bold)",
            "flatpak" => $"(ansi cyan_bold)",
            "snap" => $"(ansi red_bold)",

             _ =>  $"(ansi white_bold)"
        }
        let number_label: string = ($"[($style)($count)(ansi reset)]:" | add-whitespace-until-string-length ( $result_max_digits + 4 ))
        let package_label: string = ($"($i.package)" | add-whitespace-until-string-length ($longest_package_name_length + 1) )
        let version_label: string = ($i.version | add-whitespace-until-string-length ($longest_version_length + 1) )
        let provider_label: string = ($"\(($style)($i.provider)(ansi reset)\)" | add-whitespace-until-string-length 11 )
        if $desc {

        let description = $" ($i.description)"
            if ($i.description | is-empty) {
                single-line-print $"($number_label)($package_label)($version_label)($provider_label)"
            } else {
                single-line-print $"($number_label)($package_label)($version_label)($provider_label)($description)"
            }
        } else {
            single-line-print $"($number_label)($package_label)($version_label)($provider_label)"
        }
        $count += 1
    }

    return $results
}


def calc-version-numbers [] -> table {
    let packages_table = $in
    print "Searching for if any of the packages are installed."
    let versions = $packages_table | par-each -k { |row| ($row.package | fetch-version $row.provider) }
    print -n $"\e[A\e[K"
    $versions | wrap version
}