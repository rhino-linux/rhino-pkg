# rhino-pkg
![Untitled-2-01](https://user-images.githubusercontent.com/104327997/220489850-17bbdafb-605d-48ed-9866-cce3821974d4.svg)

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
             individual packages. Has confirmation prompt.

flags: 
    --help/-h: Display this page
    
    --description/-d: By default, rhino-pkg will only display packages 
    that contain <input> within their name. Use this flag to increase 
    range and display packages with <input> in their description.
    
input: 
    Provide a package name or description.

Example execution:
       >>> rhino-pkg install foobar
       Searching...
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

### How you can help
* Work on translations into languages not finished yet by either editing the `po/<language_code>.po` file, making a new one by running `cp po/rhino-pkg.pot po/<language_code>.po`, or using weblate (https://weblate.makedeb.org/projects/rhino-linux/rhino-pkg/). Once you have completed or partially completed a po file, make a PR and we will merge it! Our goal is to have as many languages translated as possible due to the amount of people who may not be fluent in English.

#### Supported languages

<a href="https://weblate.makedeb.org/engage/rhino-linux/">
<img src="https://weblate.makedeb.org/widgets/rhino-linux/-/rhino-pkg/multi-blue.svg" alt="Translation status" />
</a>
