# Clear screen with tput
export def clearscr [] {
    ^tput cuu 1
    ^tput el
}
