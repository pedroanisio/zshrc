➜  ~ cat .zshrc 
#######################################################################
# ~/.zshrc – Professional Zsh Configuration
# Author: Generated for Dell G15 Ubuntu setup
# Updated: 2024
#######################################################################

#######################################################################
# 0. Profiling (uncomment to debug slow startup)
#######################################################################
# zmodload zsh/zprof

#######################################################################
# 1. Oh-My-Zsh Bootstrap
#######################################################################
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Disable Oh-My-Zsh auto-update prompts (update manually)
zstyle ':omz:update' mode disabled

[[ -s "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

#######################################################################
# 2. Shell Options
#######################################################################
# Navigation
setopt autocd              # cd by typing directory name
setopt autopushd           # Push dirs to stack (cd -, popd)
setopt pushdsilent         # Don't print stack after pushd
setopt pushdminus          # Swap +/- for pushd

# Globbing & Expansion
setopt extendedglob        # Extended globbing (^, ~, #)
setopt nomatch             # Error on no glob match
setopt nullglob            # Empty result for no match (scripts)

# Safety
setopt noclobber           # Prevent > overwrite (use >|)
setopt correct             # Suggest corrections for commands
# setopt correctall        # Uncomment to also correct arguments

# Jobs
setopt longlistjobs        # List jobs in long format
setopt notify              # Report job status immediately

# Misc
setopt interactivecomments # Allow comments in interactive shell
setopt promptsubst         # Enable prompt substitution

#######################################################################
# 3. History
#######################################################################
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt appendhistory          # Append, don't overwrite
setopt histignorealldups      # Remove older duplicates
setopt histignorespace        # Ignore commands starting with space
setopt histreduceblanks       # Trim whitespace
setopt histverify             # Show expanded history before executing
setopt sharehistory           # Share across sessions
setopt incappendhistory       # Add commands immediately

#######################################################################
# 4. Key Bindings
#######################################################################
bindkey -e                              # Emacs mode

# Navigation
bindkey '^[[H'    beginning-of-line     # Home
bindkey '^[[F'    end-of-line           # End
bindkey '^[[3~'   delete-char           # Delete
bindkey '^[[1;5C' forward-word          # Ctrl+Right
bindkey '^[[1;5D' backward-word         # Ctrl+Left

# History search (type prefix, then arrow up/down)
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Ctrl+Z to fg (toggle background)
_zsh_cli_fg() { fg; }
zle -N _zsh_cli_fg
bindkey '^Z' _zsh_cli_fg

#######################################################################
# 5. Completion System
#######################################################################
autoload -Uz compinit

# Rebuild completion cache once daily
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion styling
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' verbose true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive

# Colors
eval "$(dircolors -b 2>/dev/null || echo 'export LS_COLORS=""')"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Prompts
zstyle ':completion:*' list-prompt '%SAt %p: Tab for more, or char to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling: %p%s'

# Process completion for kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# SSH/SCP host completion from known_hosts
zstyle ':completion:*:(ssh|scp|rsync):*' hosts ${(f)"$(awk '/^Host / && !/\*/ {print $2}' ~/.ssh/config 2>/dev/null)"}

# Directories
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

#######################################################################
# 6. Path Configuration
#######################################################################
typeset -U path  # Unique entries only

path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$HOME/code/review/_devtools"
  "/usr/local/bin"
  $path
)

export PATH

#######################################################################
# 7. Environment Variables
#######################################################################
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export LESS='-R -F -X -i -M -S'

# Locale
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ -d "$PNPM_HOME" ]] && path+=("$PNPM_HOME")

#######################################################################
# 8. NVM (Lazy-loaded for fast startup)
#######################################################################
export NVM_DIR="$HOME/.nvm"

if [[ -d "$NVM_DIR" ]]; then
  # Lazy load NVM - only initialize when first called
  _nvm_lazy_load() {
    unset -f nvm node npm npx pnpm yarn 2>/dev/null
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  }

  nvm()  { _nvm_lazy_load; nvm "$@"; }
  node() { _nvm_lazy_load; node "$@"; }
  npm()  { _nvm_lazy_load; npm "$@"; }
  npx()  { _nvm_lazy_load; npx "$@"; }
  pnpm() { _nvm_lazy_load; pnpm "$@"; }
  yarn() { _nvm_lazy_load; yarn "$@"; }
fi

export HOST_SLUG=$(hostname | tr '[:upper:]' '[:lower:]')
#######################################################################
# 9. Aliases
#######################################################################

alias sync-home="rclone bisync /$HOME onedrv:/host/\$HOST_SLUG/\$USER \
  --exclude-from /$HOME/\.config/rclone/exclude-home.txt \
  --progress \
  --max-delete 100"

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Listing (use eza if available, else ls)
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --group-directories-first'
  alias la='eza -la --icons --group-directories-first'
  alias lt='eza -T --icons --level=2'
else
  alias ls='ls --color=auto'
  alias ll='ls -lh'
  alias la='ls -lAh'
fi

# Safety
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -I'
alias ln='ln -iv'

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Disk usage
alias df='df -h'
alias du='du -h'
alias dud='du -d 1 -h'
alias duf='du -sh *'

# Git shortcuts (supplement oh-my-zsh git plugin)
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --graph --decorate -20'

# Docker
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias dpa='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias dimg='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'
alias dex='docker exec -it'
alias dlogs='docker logs -f'
alias dstop='docker stop $(docker ps -q)'
alias dprune='docker system prune -af'

# System
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me'
alias reload='source ~/.zshrc'

# Tree with .gitignore support
alias tree='tree -I ".git|node_modules|__pycache__|.venv|venv"'
alias treeg='tree --gitignore 2>/dev/null || tree'

# Quick clear + command
alias c='clear'
alias cc='clear; cat'
alias cl='clear; ls'


#######################################################################
# 10. Functions
#######################################################################
# Create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract any archive
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.tar.xz)  tar xJf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *.rar)     unrar x "$1" ;;
      *)         echo "Cannot extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find process by name
psg() { ps aux | grep -v grep | grep -i "$1"; }

# Quick backup
bak() { cp -a "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"; }

# Show top N largest files in directory
bigfiles() { find "${1:-.}" -type f -exec du -h {} + | sort -rh | head -n "${2:-10}"; }

# HTTP server in current directory
serve() { python3 -m http.server "${1:-8000}"; }

# Weather (wttr.in)
weather() { curl -s "wttr.in/${1:-}?format=3"; }

#######################################################################
# 11. Command Timer
#######################################################################
_cmd_start=
_cmd_name=

preexec() {
  _cmd_start=$SECONDS
  _cmd_name="$1"
}

precmd() {
  local elapsed
  if [[ -n "$_cmd_start" ]]; then
    elapsed=$((SECONDS - _cmd_start))
    if (( elapsed >= 3 )); then
      printf '\e[90m# %s took %ds\e[0m\n' "${_cmd_name%% *}" "$elapsed"
    fi
  fi
  _cmd_start=
  _cmd_name=
}

#######################################################################
# 12. direnv Integration
#######################################################################
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

#######################################################################
# 13. FZF Integration (if installed)
#######################################################################
if command -v fzf &>/dev/null; then
  # Use fd if available (faster than find)
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  fi

  export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --inline-info
    --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
    --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
  '

  # Source fzf keybindings if available
  [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && \
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && \
    source /usr/share/doc/fzf/examples/completion.zsh
fi

#######################################################################
# 14. Local Overrides
#######################################################################
# Source machine-specific config if exists
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

#######################################################################
# 15. Cleanup & Final
#######################################################################
# Remove duplicate path entries (safety net)
typeset -U PATH path

# Profiling end (uncomment with section 0)
# zprof
