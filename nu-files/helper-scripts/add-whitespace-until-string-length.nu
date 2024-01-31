#USAGE: adds whitespace to the end of a string $in until it is $length characters long
export def main [length: int, --front (-f)] -> string {
    let input: string = $in
    let amount = ($length - ($input | ansi strip | str length --grapheme-clusters))
    mut whitespace_string = $input
    for _ in 0..<$amount {
        if not $front {
            $whitespace_string += " "
        } else {
            $whitespace_string = " " + $whitespace_string
        }
    }
    $whitespace_string
}