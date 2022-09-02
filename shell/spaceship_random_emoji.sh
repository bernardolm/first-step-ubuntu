function spaceship_random_emoji() {
    # If SPACESHIP_RANDOM_EMOJI_SHOW is false, don't show RANDOM_EMOJI section
    [[ $SPACESHIP_RANDOM_EMOJI_SHOW == false ]] && return

    # Use quotes around unassigned local variables to prevent
    # getting replaced by global aliases
    # http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Aliasing
    source $DOTFILES/shell/random_emoji.sh
    local emoji="$(random_emoji)"

    spaceship::exists random_emoji || return

    # Exit section if variable is empty
    [[ -z $emoji ]] && return

    export SPACESHIP_RANDOM_EMOJI_COLOR=${SPACESHIP_RANDOM_EMOJI_COLOR="white"}
    export SPACESHIP_RANDOM_EMOJI_PREFIX=${SPACESHIP_RANDOM_EMOJI_PREFIX=""}
    export SPACESHIP_RANDOM_EMOJI_SHOW=${SPACESHIP_RANDOM_EMOJI_SHOW=true}
    export SPACESHIP_RANDOM_EMOJI_SUFFIX=${SPACESHIP_RANDOM_EMOJI_SUFFIX=" "}
    export SPACESHIP_RANDOM_EMOJI_SYMBOL=${SPACESHIP_RANDOM_EMOJI_SYMBOL=$emoji}

    # Display RANDOM_EMOJI section
    spaceship::section::v4 \
        --color "$SPACESHIP_RANDOM_EMOJI_COLOR" \
        --prefix "$SPACESHIP_RANDOM_EMOJI_PREFIX" \
        --suffix "$SPACESHIP_RANDOM_EMOJI_SUFFIX" \
        --symbol "$SPACESHIP_RANDOM_EMOJI_SYMBOL"
}
