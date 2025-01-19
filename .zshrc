# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
# plug "zap-zsh/exa"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
# plug "zettlrobert/simple-prompt"

# Load and initialise completion system
autoload -Uz compinit
compinit

# Init zoxide
eval "$(zoxide init zsh)"

# User configuration
alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-kick="NVIM_APPNAME=KickstartNeovim nvim"
alias nvim-chad="NVIM_APPNAME=NvChad nvim"
# alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

# Neovim distros control
function nvims() {
  items=("default" "KickstartNeovim" "LazyVim" "NvChad")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# bindkey -s ^a "nvims\n"

bindkey -s "\C-a" "nvims"

# On-demand rehash
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd

# omz
alias zshconfig="geany ~/.zshrc"
alias ohmyzsh="thunar ~/.oh-my-zsh"

# ls
alias l='ls -lh'
alias ll='ls -lah'
alias la='ls -A'
alias lm='ls -m'
alias lr='ls -R'
alias lg='ls -l --group-directories-first'

# go
alias gr='go run .'
alias gmi='go mod init'
alias gmt='go mod tidy'
alias grc='go run -gcflags -m .'

# terminal
alias cl='clear'
alias th='touch'
alias mk='mkdir'
alias ls='eza -lag --icons --color=always --group-directories-first --no-git --no-permissions --grid --hyperlink --header --time-style=iso --sort=size'
alias lg='eza -lag --icons --color=always --group-directories-first --grid --hyperlink --header --git --git-ignore --sort=modified --no-permissions --git-repos'
alias tr='echo $PATH | tr : '\n''

# git
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gpu='git push -u origin main'
alias gp='git push'
alias gst='git status'

#rust
alias cr='cargo run'
alias cb='cargo build'
alias cn='cargo new'
alias cc='cargo check'
alias cbr='cargo build --release'
alias cws='cargo watch -w src -x run'
alias ct='cargo test'
alias tree='tree -I target'

# pnpm
alias p='pnpm install'
alias pd='pnpm dlx'
alias pa='pnpm add'

# bun completions
[ -s "/home/memnoc/.bun/_bun" ] && source "/home/memnoc/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fpath+=${ZDOTDIR:-~}/.zsh_functions
