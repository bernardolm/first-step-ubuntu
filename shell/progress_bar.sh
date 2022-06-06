function progress_bar() {
    local bar_size=300
    local bar=""
    local current=$1
    local left_char="█"
    local right_char="░"
    local target=$2

    local terminal_size=$(tput cols)
    local target_char_size=$(expr length $target)
    local left_message="▁ $(eval printf %${target_char_size}s $current)/$target "
    
    local percent
    ((percent=100*$current/$target))
    local right_message=" $(printf %3s $percent)% "

    local messages_size=$(expr length "${left_message}${right_message}")
    local total_size
    ((total_size=$messages_size+$bar_size))

    if [ $total_size -gt $terminal_size ]; then
        ((bar_size=$terminal_size-$messages_size));
    fi

    local position
    ((position=($bar_size*$percent)/100))

    for ((left=0; left<$position; left++)); do bar+=$left_char; done
    for ((right=$position; right<$bar_size; right++)); do bar+=$right_char; done
    echo -ne "$left_message$bar$right_message\r"
}
