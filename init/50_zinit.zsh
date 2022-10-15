function zinit_runner() {
    local params=($*)

    [ ${#params[@]} -le 1 ] \
        && notice "\"$params\" not enought params, exiting..." \
        && return false

    local cmd_mode=${params[1]}
    params=("${params[@]:1}")

    [[ ! "(debug turbo echo start omz)" =~ "$cmd_mode" ]] \
        && notice "\"$cmd_mode\" isn't a known command, exiting..." \
        && return false

    [[ "$cmd_mode" = "debug" ]] && cmd="zinit load "
    [[ "$cmd_mode" = "echo" ]] && cmd="echo -n "
    [[ "$cmd_mode" = "start" ]] && cmd="zinit light "
    [[ "$cmd_mode" = "turbo" ]] && cmd="zinit ice wait lucid; zinit load "
    [[ "$cmd_mode" = "omz" ]] && cmd="zinit snippet OMZ"

    if [ "$cmd_mode" != "echo" ]; then
        $DEBUG_SHELL && notice "zinit loading plugins with '$cmd_mode' mode ($cmd):"
        for p in $params; do
            $DEBUG_SHELL && notice "> $cmd$p"
            eval "$cmd$p 1>/dev/null"
        done
        $DEBUG_SHELL && notice "zinit $cmd_mode finished"
    else
        $DEBUG_SHELL && notice "zinit will not be loading follow plugins:"
        $DEBUG_SHELL && notice ${params[@]}
    fi

    $DEBUG_SHELL && notice ""
}

function zinit_start() {
    source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit

    zinit light-mode for \
        zdharma-continuum/zinit-annex-as-monitor \
        zdharma-continuum/zinit-annex-bin-gem-node \
        zdharma-continuum/zinit-annex-patch-dl \
        zdharma-continuum/zinit-annex-rust
}

$DEBUG_SHELL && typeset -g ZPLG_MOD_DEBUG=1

if [[ ! -d $ZINIT_ROOT ]]; then
    $DEBUG_SHELL && notice "zinit not found ($ZINIT_ROOT), installing..."

    local zinit_url="https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh"

    export NO_ANNEXES=yes
    export NO_COLOR=yes
    export NO_EDIT=yes
    export NO_EMOJI=yes
    export NO_INPUT=yes

    bash -c "$(curl --fail --show-error --silent --location $zinit_url)" 1>/dev/null

    zinit_start
    zinit self-update &>/dev/null

    zinit_runner turbo $(cat $DOTFILES/zinit/plugins.txt | grep -v '#')
    zinit_runner omz $(cat $DOTFILES/zinit/ohmyzsh.txt | grep -v '#')
else
    zinit self-update &>/dev/null
    zinit update --parallel &>/dev/null
fi

zinit_start
