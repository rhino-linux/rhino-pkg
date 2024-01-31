use "./translation-dir-path.nu" main

export def main [ input: table , purpose: string ] -> table {
    mut user_input = ""
    print ""
    let input_final_index = ($input | length) - 1

   $user_input = match $purpose {
        "install" => (input (translation-dir-path| translate ask.which-install {index: $input_final_index}) | into string),      
        "info" => (input (translation-dir-path |  translate ask.which-info{ index: $input_final_index }) |into string),
        "remove" => (input (translation-dir-path| translate ask.which-remove {index: $input_final_index}) | into string),
        _ => []
    }

    #uses regex to filter out non-number inputs, then converts to int
    mut user_input_ints = ($user_input | split row ' ' | find --regex "[0-9]+" | find --regex "^[0-9]+" | into int) 
    
    #screens the list for invalid indices
    mut drop_list: list<int> = []
    for i in 0..<($user_input_ints | length) {
        if ($user_input_ints |select $i).0 > $input_final_index {
            $drop_list = ($drop_list | append $i)
        }  
    }
    #prunes invalid indices
    for i in 0..<($drop_list|length) {
        $user_input_ints = ($user_input_ints | drop nth ($drop_list| select $i).0)
    }

    #user provided no numbers that were valid
    if ($user_input_ints | is-empty) {
        let error_msg = translation-dir-path | translate invalid.integers {number: $input_final_index}
        error make {msg: $error_msg}
    }
    $user_input_ints
}