# Created by newuser for 5.9
# ~/.zshrc

# PATH configuration
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Environment

# Default        "*?_-.[]~=/&;!#$%^(){}<>"
export WORDCHARS="*?_-[]~=&!#$%^(){}<>"

# Enable color support for less
export MANROFFOPT=-c
export LESS='-R'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# Colored aliases for common commands
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# Bindings
bindkey '\e[3~' delete-char              # Delete key (forward delete)
bindkey '^?' backward-delete-char        # Backspace key (backward delete)

# Optional: Home and End keys while you're at it
bindkey '\e[1~' beginning-of-line        # Home key
bindkey '\e[4~' end-of-line              # End key

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^H' backward-kill-word

# Disable mouse reporting to fix touchpad scrolling
printf '\e[?1000l'

# Zsh prompt with colors using prompt expansion
# Green: username@hostname and colon
# Blue: current directory
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%# '

# Alternative if you prefer the $ symbol for normal users and # for root
# PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%(!.#.$) '

# Zsh history settings
HISTSIZE=1000
SAVEHIST=2000
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Zsh options
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # push directories onto directory stack
setopt PUSHD_IGNORE_DUPS    # don't push duplicates
setopt EXTENDED_GLOB        # extended globbing
setopt NO_CASE_GLOB         # case-insensitive globbing
setopt NUMERIC_GLOB_SORT    # sort numerically

# Completion system
autoload -Uz compinit
compinit

# Enable colors in zsh
autoload -Uz colors
colors

# Correction for commands
# setopt CORRECT_ALL

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

# Source local config if exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

eval "$(starship init zsh)"
