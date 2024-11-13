export ZSH=$DOTFILES/zsh

source "$ZDOTDIR/.zsh_functions"

########################################################
# Configuration
########################################################

# initialize autocomplete
autoload -U compinit add-zsh-hook
compinit

prepend_path /usr/local/opt/grep/libexec/gnubin
prepend_path /usr/local/sbin
prepend_path $DOTFILES/bin
prepend_path $HOME/bin

# SQSP
prepend_path $HOME/squarespace/generated/bin
prepend_path $HOME/workspace/sqsp/kubectl-plugins
prepend_path $(pyenv root)/shims

# define the code directory
# This is where my code exists and where I want the `c` autocomplete to work from exclusively
if [[ -d ~/code ]]; then
    export CODE_DIR=~/code
elif [[ -d ~/Developer ]]; then
    export CODE_DIR=~/Developer
fi

# display how long all tasks over 10 seconds take
export REPORTTIME=10
export KEYTIMEOUT=1              # 10ms delay for key sequences

setopt NO_BG_NICE
setopt NO_HUP                    # don't kill background jobs when the shell exits
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt PROMPT_SUBST

# history
setopt EXTENDED_HISTORY          # write the history file in the ":start:elapsed;command" format.
setopt HIST_REDUCE_BLANKS        # remove superfluous blanks before recording entry.
setopt SHARE_HISTORY             # share history between all sessions.
setopt HIST_IGNORE_ALL_DUPS      # delete old recorded entry if new entry is a duplicate.

setopt COMPLETE_ALIASES

# make terminal command navigation sane again
bindkey "^[[1;5C" forward-word                      # [Ctrl-right] - forward one word
bindkey "^[[1;5D" backward-word                     # [Ctrl-left] - backward one word
bindkey '^[^[[C' forward-word                       # [Ctrl-right] - forward one word
bindkey '^[^[[D' backward-word                      # [Ctrl-left] - backward one word
bindkey '^[[1;3D' beginning-of-line                 # [Alt-left] - beginning of line
bindkey '^[[1;3C' end-of-line                       # [Alt-right] - end of line
bindkey '^[[5D' beginning-of-line                   # [Alt-left] - beginning of line
bindkey '^[[5C' end-of-line                         # [Alt-right] - end of line
bindkey '^?' backward-delete-char                   # [Backspace] - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
    bindkey "${terminfo[kdch1]}" delete-char        # [Delete] - delete forward
else
    bindkey "^[[3~" delete-char                     # [Delete] - delete forward
    bindkey "^[3;5~" delete-char
    bindkey "\e[3~" delete-char
fi
bindkey "^A" vi-beginning-of-line
bindkey -M viins "^F" vi-forward-word               # [Ctrl-f] - move to next word
bindkey -M viins "^E" vi-add-eol                    # [Ctrl-e] - move to end of line
bindkey "^J" history-beginning-search-forward
bindkey "^K" history-beginning-search-backward

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''


########################################################
# Plugin setup
########################################################

export ZPLUGDIR="$CACHEDIR/zsh/plugins"
[[ -d "$ZPLUGDIR" ]] || mkdir -p "$ZPLUGDIR"
# array containing plugin information (managed by zfetch)
typeset -A plugins

zfetch mafredri/zsh-async async.plugin.zsh
zfetch zsh-users/zsh-syntax-highlighting
zfetch zsh-users/zsh-autosuggestions
zfetch grigorii-zander/zsh-npm-scripts-autocomplete
zfetch Aloxaf/fzf-tab

# xkb
zfetch "qoomon/zjump" zjump.plugin.zsh
zfetch "wfxr/forgit" forgit.plugin.zsh
zfetch "MichaelAquilina/zsh-autoswitch-virtualenv" autoswitch_virtualenv.plugin.zsh
zfetch "MichaelAquilina/zsh-autoswitch-virtualenv" autoswitch_virtualenv.plugin.zsh
# zfetch "wookayin/fzf-fasd" fzf-fasd.plugin.zsh

# prepend_path $HOME/.jenv/bin
# zfetch "shihyuho/zsh-jenv-lazy" jenv-lazy.plugin.zsh
source $HOME/.sdkman/bin/sdkman-init.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
prepend_path $HOME/.rvm/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

## gcloud
# source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
# source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

if [[ -x "$(command -v fnm)" ]]; then
    eval "$(fnm env --use-on-cd)"
fi

[[ -e ~/.terminfo ]] && export TERMINFO_DIRS=~/.terminfo:/usr/share/terminfo

########################################################
# Setup
########################################################

if [ -f $HOME/.fzf.zsh ]; then
  source $HOME/.fzf.zsh
  export FZF_DEFAULT_COMMAND='fd --hidden --follow'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS="--color bg:-1,bg+:-1,fg:-1,fg+:#feffff,hl:#993f84,hl+:#d256b5,info:#676767,prompt:#676767,pointer:#676767"
fi

# add a config file for ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.rgrc"

# add color to man pages
export MANROFFOPT='-c'
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)

# prefer zoxide over z.sh
if [[ -x "$(command -v zoxide)" ]]; then
    eval "$(zoxide init zsh --hook pwd)"
else
  # source z.sh if it exists
  zpath="$(brew --prefix)/etc/profile.d/z.sh"
  if [ -f "$zpath" ]; then
      source "$zpath"
  fi
fi

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # macOS `ls`
    colorflag="-G"
fi

# If a ~/.zshrc.local exists, source it
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# If a ~/.localrc zshrc exists, source it
[[ -a ~/.localrc ]] && source ~/.localrc

# look for all .zsh files and source them
for file in "$ZDOTDIR/.zsh_prompt" "$ZDOTDIR/.zsh_aliases"; do
    if [ -f $file ]; then
        source $file
    fi
done

## XKB

# Java 11 for V6
export JAVA_TARGET_COMPATIBILITY_VERSION="11"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# pyenv
# export PYENV_SHELL=zsh
# source '/opt/homebrew/Cellar/pyenv/2.2.4-1/libexec/../completions/pyenv.zsh'
# command pyenv rehash 2>/dev/null
# pyenv() {
#   local command
#   command="${1:-}"
#   if [ "$#" -gt 0 ]; then
#     shift
#   fi

#   case "$command" in
#   rehash|shell)
#     eval "$(pyenv "sh-$command" "$@")"
#     ;;
#   *)
#     command pyenv "$command" "$@"
#     ;;
#   esac
# }

eval "$(pyenv virtualenv-init -)"

if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/kbaaba/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)