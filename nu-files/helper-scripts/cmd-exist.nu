export def main [input: string] -> bool {
    let stuff = (which $input)
    if ($stuff | is-empty) { return false } else if ($stuff).type.0 == "external" { return true }
}