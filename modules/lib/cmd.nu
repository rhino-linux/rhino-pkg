export def exists [cmd: string] -> bool {
    ((which $cmd | length) > 0)
}
