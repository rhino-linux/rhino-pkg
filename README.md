# rhino-pkg

A package manager wrapper for Pacstall, apt, flatpak and snap.

### Usage
```
USAGE: rhino-pkg [subcommand] {flags} [input]

input: Provide package name or description

subcommand:
    install: install a package
    search: searches for packages

flags:
    --help/-h: Display this page
    --description/-d: Displays packages with [input] in their description (if available)
```

### How you can help
* Work on translations into languages not finished yet by either editing the `po/<language_code>.po` file, making a new one by running `cp po/rhino-pkg.pot po/<language_code>.po`, or using weblate (https://weblate.makedeb.org/projects/rhino-linux/rhino-pkg/). Once you have completed or partially completed a po file, make a PR and we will merge it! Our goal is to have as many languages translated as possible due to the amount of people who may not be fluent in English.

#### Supported languages

<a href="https://weblate.makedeb.org/engage/rhino-linux/">
<img src="https://weblate.makedeb.org/widgets/rhino-linux/-/rhino-pkg/multi-blue.svg" alt="Translation status" />
</a>
