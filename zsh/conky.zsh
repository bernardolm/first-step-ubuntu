function conky_kill() {
    killall -9 conky 2>/dev/null
}

function conky_start() {
    unset DEBUG

    local attrs="--quiet --daemonize"
    if [ ! -z "$DEBUG" ]; then
        attrs=" -D "
    fi

    local cmd="conky ${attrs} --config"

    # eval ${cmd} "$DOTFILES/.config/conky/left.conf"
    eval "${cmd} ${DOTFILES}/.config/conky/right.conf"
}

function conky_instances() {
    ps auxwf | grep -v grep | grep "_ conky" | wc -l | bc
}

function conky_restart() {
    local instaces
    instaces=$(conky_instances)
    # notify-send "conky (re)starting" "$(conky_instances) were running."
    conky_kill
    sleep 1
    conky_start
}
