# apply defaults settings
emulate -LR zsh

# Output the name of each file it loads
# setopt SOURCE_TRACE

export EDITOR=nvim
export VISUAL=nvim
export KUBE_EDITOR=nvim

source "$ZDOTDIR/zsh-functions"
zsh_add_plugin "reegnz/jq-zsh-plugin"
zsh_add_plugin "zsh-users/zsh-autosuggestions" 
# zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
# zsh_add_plugin "hlissner/zsh-autopair"
# zsh_add_plugin "Aloxaf/fzf-tab"
zsh_add_plugin "rupa/z"

# zsh_add_file "$ZDOTDIR/.exports"
# zsh_add_file "$ZDOTDIR/.aliases"
# zsh_add_file "$ZDOTDIR/.functions"
# zsh_add_file "$ZDOTDIR/.keybindings"

for file in $ZDOTDIR/.{exports,aliases,functions,keybindings}; do
  source "$file"
done

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

setopt inc_append_history
setopt share_history

setopt autocd autopushd extendedglob nomatch menucomplete
setopt interactive_comments

# General options
setopt correct
setopt extendedglob
setopt nocaseglob
setopt rcexpandparam
setopt nocheckjobs
setopt numericglobsort

stty stop undef # Disable ctrl-s to freeze terminal
zle_highlight=('paste:none')

# export MANPAGER="nvim +Man!"
# export MANPAGER="nvim -c 'set ft=man' -"


unsetopt BEEP

autoload -Uz compinit
zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select
zmodload zsh/complist
_comp_options+=(globdots)

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

autoload -Uz colors && colors

# Use bash-like word definitions for navigation and operations
autoload -Uz select-word-style && select-word-style bash

if [ -f ~/.fzf.zsh ] && [ -z $FZF_LOADED ]; then 
  FZF_LOADED=1
  source ~/.fzf.zsh
  source ~/.fzf-utils.sh
fi

. "$HOME/.cargo/env"
. "$ZDOTDIR/plugins/z/z.sh"

eval "$(pyenv init --path)"
eval "$(starship init zsh)"

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

autoload -Uz compinit

for dump in ~/.zcompdump(N.mh+24); do
    compinit
done

compinit -C

# TODO: figure out why this needs to be below compinit
# also is there a better way of doing this
. <(kubectl completion zsh)

#  brew install zsh-syntax-highlighting
if [ -e /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ -z ZSH_HIGHLIGHTING_LOADED ]; then 
  ZSH_HIGHLIGHT_MAXLENGTH=512
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHTING_LOADED=1
fi

# if [ -z "$KUBECONFIG" ] && [ -f ~/.kube/config ]; then
#   KUBECONFIG="~/.kube/config"
# fi

