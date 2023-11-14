# rhino-pkg
<img width="400" alt="placeholder-rpk" src="https://github.com/rhino-linux/rhino-pkg/assets/104327997/f1089f8d-4caa-4b27-83b7-9cc0a12ab5dc">

A package manager wrapper for Pacstall, APT, Flatpak and snap.

### Usage
```
USAGE: rhino-pkg [function] {flag} <input>                                                  

functions:
    install: Install package(s) - Prompts user to respond with 
             the number(s) associated with the desired package(s).
             
    remove:  Uninstall package(s) - Prompts user to respond with
             the number(s) associated with the desired package(s).
             
    search:  Search for package(s) - Does not have a second prompt.
    
    update:  Updates all packages accessible to the wrapper - does
             not accept <input>, instead use install to update 
             individual packages. Has a confirmation prompt.

    cleanup: Attempts to repair broken dependencies and remove any
             unused packages. Does not accept <input>, but has 
             a confirmation prompt.

flags: 
    --help/-h: Display this page
    
    --description/-d: By default, rhino-pkg will only display packages 
    that contain <input> within their name. Use this flag to increase 
    range and display packages with <input> in their description.

    -y: Makes functions with confirmation prompts run promptless.
    
input: 
    Provide a package name or description.

Example execution:
    $ rhino-pkg install foobar
    Found packages matching 'foobar':

    [0]: pyfoobar (apt)
    [1]: foobarshell (apt)
    [2]: foobar (flatpak)
    [3]: foobar-web (snap)
    [4]: foobar-bin (pacstall)
    [5]: foobar-theme (pacstall)

    Select which package to install [0-5]: 3 4 5
    Selecting 'foobar-web' from package manager 'snap'
    Selecting 'foobar-bin' from package manager 'pacstall'
    Selecting 'foobar-theme' from package manager 'pacstall'
    Are you sure? (y/N)
    [...]
```
