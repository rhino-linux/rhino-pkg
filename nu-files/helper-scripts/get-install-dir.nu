export def main [] -> path {

    use ./raw-install-dir.nu
    let rhino_pkg_path: string = ([ raw-install-dir, "nu-files/rhino-pkg"] | str join)
    let rhino_pkg_exists: bool = ( $rhino_pkg_path | path exists)

    if rhino-pkg-exists {
         raw-install-dir

# This code is a remnant of when I was making rhino-pkg check to see if the given path contained an outdated installation.
# In hindsight I decided that it would be wasting execution time
#       let days_since_accessed: float = (((^date +%s | into int) - (^stat --format=%X rhino-pkg | into int)) | into float) / 86400.0

    } else {
        # gets the new dir from dpkg
        let new_install_path: path = request-dpkg-for-install-path
        # obtains the path of the raw-install-dir.nu file
        let raw_install_dir_nu_path: path = ([$new_install_path, "nu-files/helper-scripts/get-install-dir/raw-install-dir.nu"] | str join)
        # opens raw-install-dir.nu
        let old_raw_install_dir_nu = open $raw_install_dir_nu_path
        # obtains the outdated dir
        let old_line: string = ($old_raw_install_dir_nu| lines | get 1)
        if ($old_line | str contains $new_install_path) {
            # this only arises in the situation where rhino-pkg
            # is running after already fixing the file but before exiting after fixing it
            # (nushell doesn't update while running when its source is updated)
            return $new_install_path
        }
        # creates the new line to replace the old one in raw-install-dir.nu
        let new_line: string = (["\t", $new_install_path ] | str join )
        # creates a new version of raw-install-dir.nu with the updated path
        let new_raw_install_dir_nu = $old_raw_install_dir_nu | str replace $old_line $new_line 
        # saves the updated version to the file
        $new_raw_install_dir_nu | save $raw_install_dir_nu_path
        
        $new_install_path

    }

}

def request-dpkg-for-install-path [] -> path {
# this line of code asks dpkg for a list of all files that have been installed via the deb package rhino-pkg
# it filters in only the ones with the path "nu-files" and selects and single one.
# it then slices off the "nu-files" and everything after, in order to leave itself with the pure share dir for rhino-pkg. 
    (^dpkg -L rhino-pkg | lines | filter { |line| $line | str contains "nu-files"} | get 0 | split row "nu-files" | get 0)
}
