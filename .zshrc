# =============================================================================
# ENVIRONMENT & PATH
# =============================================================================

# Rust / Cargo
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Keep repeated shell startup from duplicating PATH entries.
typeset -U path PATH

# Bob (Neovim version manager)
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

# Local bins (fd symlink, custom scripts)
export PATH="$HOME/.local/bin:$PATH"

# N (Node version manager)
export N_PREFIX="$HOME/n"
export PATH="$N_PREFIX/bin:$PATH"

# fnm (Node version manager) on machines that use it instead of n
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Linuxbrew (keep if actively used, remove if not)
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# XDG base dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Default editor: Uzume where installed, otherwise plain nvim
if command -v uzume >/dev/null; then
  export EDITOR="uzume"
else
  export EDITOR="nvim"
fi
export VISUAL="$EDITOR"

# Wayland clipboard support for Neovim (Linux only)
[[ "$OSTYPE" == linux* ]] && export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"

# Homebrew LLVM tools (appended: Apple clang stays default)
[[ -d /opt/homebrew/opt/llvm/bin ]] && export PATH="$PATH:/opt/homebrew/opt/llvm/bin"

# =============================================================================
# ZAP PLUGIN MANAGER
# =============================================================================

[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && \
  source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

if (( $+functions[plug] )); then
  plug "zsh-users/zsh-autosuggestions"
  plug "zap-zsh/supercharge"
fi

# =============================================================================
# COMPLETION
# =============================================================================

if (( ! $+_comps )); then
  autoload -Uz compinit
  compinit
fi

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Color completion menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Use fzf-tab for completion menus
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# =============================================================================
# HISTORY
# =============================================================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# =============================================================================
# KEYBINDINGS
# =============================================================================

bindkey -e
# Ctrl+A → nvims launcher
bindkey -s "\C-a" "nvims\n"
# Ctrl+R fallback; fzf replaces it below when installed.
bindkey '^R' history-incremental-search-backward

# =============================================================================
# ZOXIDE
# =============================================================================

(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# =============================================================================
# FZF
# =============================================================================

# ~/.fzf.zsh comes from fzf's git installer; distro/brew packages use `fzf --zsh`
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'

# =============================================================================
# STARSHIP PROMPT
# =============================================================================

(( $+commands[starship] )) && eval "$(starship init zsh)"

# =============================================================================
# ON-DEMAND REHASH (Linux APT only)
# =============================================================================

if [[ "$OSTYPE" == linux* && -e /var/cache/apt/pkgcache.bin ]]; then
  zshcache_time=$(stat -c %Y /var/cache/apt/pkgcache.bin)
  autoload -Uz add-zsh-hook
  rehash_precmd() {
    [[ -e /var/cache/apt/pkgcache.bin ]] || return 0
    local aptcache_time=$(stat -c %Y /var/cache/apt/pkgcache.bin)
    if [[ "$zshcache_time" != "$aptcache_time" ]]; then
      rehash
      zshcache_time="$aptcache_time"
    fi
  }
  add-zsh-hook -Uz precmd rehash_precmd
fi

# =============================================================================
# NEOVIM CONFIG SWITCHER
# =============================================================================

if [[ -d "$XDG_CONFIG_HOME/LazyVim" ]]; then
  alias nvim-lazy='NVIM_APPNAME=LazyVim nvim'
elif [[ -f "$XDG_CONFIG_HOME/nvim/lazyvim.json" ]]; then
  alias nvim-lazy='nvim'
fi
[[ -d "$XDG_CONFIG_HOME/KickstartNeovim" ]] && alias nvim-kick='NVIM_APPNAME=KickstartNeovim nvim'
[[ -d "$XDG_CONFIG_HOME/NvChad" ]] && alias nvim-chad='NVIM_APPNAME=NvChad nvim'

function nvims() {
  local config candidate
  local -a items=(default)
  for candidate in KickstartNeovim LazyVim NvChad FrontVim MemnocVim uzume; do
    [[ -d "$XDG_CONFIG_HOME/$candidate" ]] && items+=("$candidate")
  done
  if (( ${#items} == 1 )); then
    env -u NVIM_APPNAME nvim "$@"
    return
  fi
  config=$(printf '%s\n' "${items[@]}" | fzf --prompt=' Neovim Config  ' \
    --height='~50%' --layout=reverse --border --exit-0) || return 0
  [[ -n "$config" ]] || return 0
  if [[ "$config" == default ]]; then
    env -u NVIM_APPNAME nvim "$@"
  else
    NVIM_APPNAME="$config" nvim "$@"
  fi
}

# =============================================================================
# ALIASES — FILESYSTEM
# =============================================================================

alias ls='eza -lag --icons --color=always --group-directories-first --no-git --no-permissions --grid --hyperlink --header --time-style=iso --sort=size'
alias lg='eza -lag --icons --color=always --group-directories-first --grid --hyperlink --header --git --git-ignore --sort=modified --no-permissions --git-repos'
alias l='eza -lh --icons --color=always'
alias ll='eza -lah --icons --color=always'
alias la='eza -A --icons --color=always'
alias lm='eza -m --icons --color=always'
alias lr='eza -R --icons --color=always'
alias tree='eza --tree --icons --color=always -I target'

alias cl='clear'
alias th='touch'
alias mk='mkdir -p'
alias tr='echo $PATH | tr : "\n"'

# hyfetch logo per machine (hyfetch.json leaves the distro to auto-detect)
if [[ "$OSTYPE" == darwin* ]]; then
  alias hyfetch='hyfetch --distro macos_small'
elif [[ -r /etc/os-release ]] && grep -q '^ID=fedora-asahi-remix' /etc/os-release; then
  alias hyfetch='hyfetch --distro asahi'
fi

# Config shortcuts
alias zshconfig="nvim ~/.zshrc"
alias starconfig="nvim ~/.config/starship.toml"

# =============================================================================
# ALIASES — GIT
# =============================================================================

alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gpu='git push -u origin main'
alias gp='git push'
alias gst='git status'
alias glo='git log --oneline --graph --decorate'
alias gd='git diff'

# =============================================================================
# ALIASES — RUST / CARGO
# =============================================================================

alias cr='cargo run'
alias cb='cargo build'
alias cn='cargo new'
# ck, not cc: cc is the C compiler
alias ck='cargo check'
alias cbr='cargo build --release'
alias cws='cargo watch -w src -x run'
alias ct='cargo test'
alias cf='cargo fmt'
alias ccl='cargo clippy'

# =============================================================================
# ALIASES — PYTHON
# =============================================================================

# Python execution
alias py='python3'
alias pip='pip3'
alias pyv='python3 --version'

# Virtual environments
alias mkenv='python3 -m venv .venv'
alias activate='source .venv/bin/activate'
alias deactivate='deactivate'

# Package management
alias pipi='pip3 install'
alias pipu='pip3 install --upgrade'
alias pipun='pip3 uninstall'
alias pipf='pip3 freeze'
alias pipfr='pip3 freeze > requirements.txt'
alias pipr='pip3 install -r requirements.txt'

# Project inspection
alias pypath='python3 -c "import sys; print(sys.path)"'
alias pysite='python3 -c "import site; print(site.getsitepackages())"'
alias pywhich='python3 -c "import sys; print(sys.executable)"'

# Running common tools
alias ipy='ipython'
alias jnb='jupyter notebook'
alias jlab='jupyter lab'

# Linting / formatting
alias black='python3 -m black'
alias ruff='python3 -m ruff'
alias mypy='python3 -m mypy'

# Testing
alias pytest='python3 -m pytest'
alias ptv='python3 -m pytest -v'
alias ptc='python3 -m pytest --cov'

# =============================================================================
# ALIASES — GO
# =============================================================================

alias gr='go run .'
alias gmi='go mod init'
alias gmt='go mod tidy'
alias grc='go run -gcflags -m .'

# =============================================================================
# ALIASES — NODE / PNPM / BUN
# =============================================================================

alias p='pnpm install'
alias pd='pnpm dlx'
alias pa='pnpm add'
alias pr='pnpm run'
alias tsc='npx tsc'

# =============================================================================
# BUN COMPLETIONS
# =============================================================================

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# =============================================================================
# ZSH FUNCTIONS PATH
# =============================================================================

fpath+=${ZDOTDIR:-~}/.zsh_functions

# Load completion and highlighting wrappers after widgets have been registered.
if (( $+functions[plug] )); then
  (( $+commands[fzf] )) && plug "Aloxaf/fzf-tab"
  plug "zsh-users/zsh-syntax-highlighting"
fi

# Call the installed statusline CLI even if another shell definition shadows it.
statusline() { command statusline "$@"; }

# Strict C build: cbuild file.c [extra gcc args]  -> binary named after the file
cbuild() {
  if [[ -z "$1" ]]; then
    echo "usage: cbuild file.c [extra gcc args]" >&2
    return 1
  fi
  local src="$1"; shift
  gcc -std=c11 -Wall -Wextra -Wpedantic -Wshadow -Wformat=2 -Wconversion -g -o "${src%.c}" "$src" "$@"
}
