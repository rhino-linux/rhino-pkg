### Issues Tracker

To report issues or propose new features for this repository, visit [our tracker](https://github.com/rhino-linux/tracker).

# rhino-pkg
<img width="400" alt="placeholder-rpk" src="https://github.com/rhino-linux/rhino-pkg/assets/104327997/f1089f8d-4caa-4b27-83b7-9cc0a12ab5dc">

A package manager wrapper for Pacstall, APT, Flatpak and Snap.

### Usage
```
USAGE:
 rpk [function] {flag} <input>

       Flag                        Description               
 -h, --help          Show this help message                  
 -d, --description   Search in and show package descriptions 
 -y, --yes           Skip confirmation prompts               

 Command                             Description                           
 search    Search for packages from all available managers                 
 install   Install packages; prompts from selection with repository search 
 remove    Uninstall packages; prompts for selection with local search     
 cleanup   Repair broken packages and remove unused dependencies           
 sync      Refresh repository data for all available managers              
 update    Refresh repository data and update all packages                 
 help      Show this help message                                          

      Usage               Flags                Variants       
 search <input>    --description          s (-d), sd          
 install <input>   --description, --yes   i (-d -y), id (-y)  
 remove <input>    --yes                  {r|rm} (-y)         
 cleanup           --yes                  c (-y)              
 sync                                     sy                  
 update            --yes                  {u|up|upgrade} (-y) 
 help                                     -h, --help          
```

### How you can help
* Work on translations into languages not finished yet by either editing the `po/<language_code>.po` file, making a new one by running `cp po/rhino-pkg.pot po/<language_code>.po`, or using weblate (https://hosted.weblate.org/projects/rhino-linux/rhino-pkg/). Once you have completed or partially completed a po file, make a PR and we will merge it! Our goal is to have as many languages translated as possible due to the amount of people who may not be fluent in English.

#### Supported languages

<a href="https://hosted.weblate.org/engage/rhino-linux/">
<img src="https://hosted.weblate.org/widgets/rhino-linux/-/rhino-pkg/multi-blue.svg" alt="Translation status" />
</a>
