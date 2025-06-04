#######################################################################
# ~/.zshrc – Consolidated configuration for Zsh                      #
# Works with plain Zsh or Oh-My-Zsh if installed                    #
#######################################################################

#######################################################################
# 0. Bootstrap – Oh-My-Zsh and direnv setup                         #
#######################################################################

# Define Oh-My-Zsh location (comment out if not using Oh-My-Zsh)
export ZSH="$HOME/.oh-my-zsh"
[[ -s "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Initialize direnv to load .envrc files automatically
eval "$(direnv hook zsh)"

#######################################################################
# 1. Prompt & appearance                                            #
#######################################################################

# Set Oh-My-Zsh theme (change to any installed theme or leave empty for default)
ZSH_THEME="robbyrussell"

#######################################################################
# 2. History behavior                                               #
#######################################################################

setopt histignorealldups  # Drop older duplicate commands
setopt sharehistory       # Share history across Zsh sessions

HISTSIZE=5000             # Lines kept in memory
SAVEHIST=5000             # Lines saved to ~/.zsh_history
HISTFILE="$HOME/.zsh_history"

#######################################################################
# 3. Key bindings                                                   #
#######################################################################

# Use Emacs-style key bindings (Ctrl-A, Ctrl-E, etc.), even if EDITOR=vi
bindkey -e

#######################################################################
# 4. Completion system                                              #
#######################################################################

autoload -Uz compinit && compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=long
zstyle ':completion:*' verbose true

# Match LS_COLORS for completion colors
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Eye-candy for large completion menus
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Highlight CPU-intensive processes in red when completing `kill`
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#######################################################################
# 5. Path & toolchain tweaks                                        #
#######################################################################

# PNPM (Node.js package manager) setup
export PNPM_HOME="$HOME/.local/share/pnpm"

# Prepend custom dev-tools and PNPM to PATH, preserving system PATH
export PATH="$HOME/code/review/_devtools:$PNPM_HOME:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

#######################################################################
# 6. Aliases                                                        #
#######################################################################

# `tree` respects .gitignore
alias tree='tree --gitignore'

# Concise `docker ps` output: IMAGE, NAMES, PORTS, STATUS, CREATED
alias dps='docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}\t{{.RunningFor}}"'

# Clear cat `clear; cat`

alias cc='clear; cat'

# Safety-first: `rm` moves files to trash (requires `trash-cli`, uncomment to enable)
# alias rm='trash-put'

#######################################################################
# 7. Miscellaneous tweaks                                           #
#######################################################################

# Auto-correct typos in directory names (e.g., `cd ..er`)
setopt correctall

# Track command execution time
preexec() { timer=${timer:-$SECONDS}; }
precmd() { [[ $timer ]] && printf '\e[90m# took %ds\e[0m\n' $((SECONDS-timer)); unset timer; }

#######################################################################
# 8. Oh-My-Zsh plugins & additional settings                       #
#######################################################################

# Load Oh-My-Zsh plugins (add more as needed, but keep minimal for speed)
plugins=(git)

# Optional: Language environment (uncomment if needed):
# export LANG=en_US.UTF-8

# Optional: Preferred editor (uncomment to set)
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Optional: Command execution time format in history (uncomment to set)
# HIST_STAMPS="yyyy-mm-dd"

#######################################################################
# 9. Final housekeeping                                             #
#######################################################################

# Apply changes: `source ~/.zshrc` or open a new terminal
# took 0s                                                                                                                                                                                   
instance-20250215-001450% 
