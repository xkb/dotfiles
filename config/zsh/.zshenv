# .zshenv is sourced on all invocations of the shell, unless the -f option is set.
# It should contain commands to set the command search path, plus other important environment variables.
# .zshenv' should not contain commands that produce output or assume the shell is attached to a tty.

export XDG_CONFIG_HOME="$HOME/.config"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

export DOTFILES="$(dirname "$(dirname "$(dirname "$(readlink "${(%):-%N}")")")")"

export CACHEDIR="$HOME/.local/share"
export VIM_TMP="$HOME/.vim-tmp"
# add a config file for ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

[[ -d "$CACHEDIR" ]] || mkdir -p "$CACHEDIR"
[[ -d "$VIM_TMP" ]] || mkdir -p "$VIM_TMP"

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local

fpath=(
    $DOTFILES/config/zsh/functions
    /usr/local/share/zsh/site-functions
    $fpath
)

typeset -aU path

export EDITOR='nvim'
export GIT_EDITOR='nvim'

export ARTIFACTORY_URL="https://artifactory.squarespace.net"
export ARTIFACTORY_USERNAME="kbaaba"
export GRADLE_OPTS="-Dgradle.wrapperUser=$ARTIFACTORY_USERNAME -Dgradle.wrapperPassword=$ARTIFACTORY_TOKEN"