use "./cmd-exist.nu" *
#USAGE: restricts the string to a single line when it prints it
export def main [ input: any = ""] {
    let pipeline: string = ($in | into string) 
    let output: string = ((($pipeline + ($input | into string)) | str replace "\n" " »|« "))
    let deansi_output = ($output | ansi strip)
    let num_of_ansis: int = ($output | split row "\e" | length) - 1
    let ansi_char_difference: int = ($output | str length --grapheme-clusters) - ($deansi_output | str length --grapheme-clusters)

    mut terminal_width = 100;
    if (cmd-exist 'tput') {
        $terminal_width = ((tput cols) | into int)
    } else if (cmd-exist 'stty') {
        $terminal_width = ((stty size| split column " ").column2.0 | into int)
    }
    
    if ($deansi_output | str length ) < ($terminal_width - 1) {
        print $output
    } else {

        (($output | str substring --grapheme-clusters 0..<(($terminal_width - 1) - 3 + $ansi_char_difference - ($num_of_ansis * 2))) + $"(ansi reset)...") | print
    }
    
}