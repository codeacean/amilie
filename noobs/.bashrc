set -o vi           # Vim mode!
stty time 0         # Timeout of stty
PS1='[\u@\h \W]\$ ' # !u

source -- ~/.local/share/blesh/ble.sh
source ~/.aliasrc # all alias
source "$HOME/.cargo/env"

eval "$(fzf --bash)" # FZF::need for keybinding or something like that
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" # brew packege manager
eval "$(atuin init bash --disable-up-arrow)"           # atuin: disable-up-arrow and init!
eval "$(/home/rafid/.local/bin/mise activate bash)"

# Functions
function y() { # yazi
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

ofix() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always {}' --layout reverse --border --select-1 --exit-0)
  if [[ -n "$file" ]]; then
    xvim "$file"
  fi
}

cdir() {
  cd $(find . -type d | fzf --layout reverse --border)
}

fk() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m --header='[kill:process]' --header-lines=1 | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -9
  fi
}

noob_git() {
  git status
  git add .
  git commit -m 'Updated'
  git push
}

####################
####   Keybinds

# Functions perform
bind '"\C-f":"ofix\n"'
bind '"\C-c":"cdir\n"'
bind '"\C-w":"fk\n"'

# builtin function
bind '"\e\C-l": clear-screen'

# normie action
bind -x '"\C-xs": source ~/.bashrc'
bind -x '"\C-xc": clear'
bind -x '"\C-xu": cd ..'
bind -x '"\C-xl": eza -l'
bind -x '"\C-xf": eza -F'
bind -x '"\C-xr": eza -R'
bind -x '"\C-xt": eza -T'

# Git related
bind -x '"\C-gs": git status'
bind -x '"\C-gr": git remote -v'
bind -x '"\C-ga": git add .'

# Launching applications
bind -x '"\C-ax": xvim'
bind -x '"\C-an": nvim'
bind -x '"\C-ay": yazi'
bind -x '"\C-at": tmux'
bind -x '"\C-ab": btop'
