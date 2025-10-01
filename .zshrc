#######################################################################
# ~/.zshrc – Consolidated configuration for Zsh
# Works with plain Zsh or Oh-My-Zsh if installed
#######################################################################

#######################################################################
# 0. Bootstrap – Oh-My-Zsh and direnv setup
#######################################################################

export ZSH="$HOME/.oh-my-zsh"
[[ -s "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Initialize direnv to load .envrc files automatically (optional)
eval "$(direnv hook zsh)"

#######################################################################
# 1. Prompt & appearance
#######################################################################

ZSH_THEME="robbyrussell"

#######################################################################
# 2. History behavior
#######################################################################

setopt histignorealldups  # Drop older duplicate commands
setopt sharehistory       # Share history across Zsh sessions
HISTSIZE=5000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"

#######################################################################
# 3. Key bindings
#######################################################################

bindkey -e

#######################################################################
# 4. Completion system
#######################################################################

autoload -Uz compinit && compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=long
zstyle ':completion:*' verbose true
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#######################################################################
# 5. Path & toolchain tweaks
#######################################################################

export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$HOME/code/review/_devtools:$PNPM_HOME:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

#######################################################################
# 6. Aliases
#######################################################################

# tree respects .gitignore
alias tree='tree --gitignore'

# Better docker ps view
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Networks}}"'

# Clear and cat
alias cc='clear; cat'

# Optional safety alias (requires trash-cli)
# alias rm='trash-put'

#######################################################################
# 7. Miscellaneous tweaks
#######################################################################

setopt correctall

# Show how long the last command took
preexec() { timer=${timer:-$SECONDS}; }
precmd() { [[ $timer ]] && printf '\e[90m# took %ds\e[0m\n' $((SECONDS-timer)); unset timer; }

#######################################################################
# 8. Oh-My-Zsh plugins
#######################################################################

plugins=(git)

#######################################################################
# 9. Node Version Manager (from original .zshrc)
#######################################################################

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

#######################################################################
# 10. Final housekeeping
#######################################################################

# Apply changes with: source ~/.zshrc
