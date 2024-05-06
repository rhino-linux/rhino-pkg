#returns the path to the translation-tomls dir
export def main [] -> string {
    use ./get-install-dir.nu
    let install_dir: path = get-install-dir 
    [ $install_dir , "translation-tomls"] | str join 
}