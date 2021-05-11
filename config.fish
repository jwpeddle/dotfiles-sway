# ******************** fish ********************
set -g fish_greeting

# ******************** defaults ********************
set -x PAGER "nvimpager"
set -x EDITOR "nvim"
set -x TERM "xterm-kitty"

# paths
fish_add_path "$HOME/.local/bin"
set -x XDG_CONFIG_HOME "$HOME/.config"

# make capslock ctrl
set -x XKB_DEFAULT_OPTIONS "ctrl:nocaps"

# ******************** other configs ********************

# run ssh-agent automatically
fish_ssh_agent

# bat
set -x BAT_THEME "Dracula"

# direnv
direnv hook fish | source

# fzf
function fish_user_key_bindings
  fish_vi_key_bindings
  fzf_key_bindings
end
set -x FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS
  --layout=reverse
  --no-info
  --border
  --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
  --preview 'bat --color=always --style=header,grid --line-range :300 {}'
"

# go
set -x GOPATH "$HOME/go"
fish_add_path "$GOPATH/bin"

# node
set -x NPM_CONFIG_PREFIX "$HOME/.node_modules"
fish_add_path "$NPM_CONFIG_PREFIX/bin"

# python / pyenv
set -x PYTHONDONTWRITEBYTECODE "1"
set -x PYENV_ROOT "$HOME/.pyenv"
fish_add_path "$PYENV_ROOT/bin"
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

# ripgrep
set -x RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"

# starship
starship init fish | source

# ******************** functions ********************
alias sudo "sudo -E"
alias update "sudo aura -Syyux && sudo aura -Ayyux"
alias icat "kitty +kitten icat"
alias dc "docker-compose"
alias dc-run "dc run --rm"
alias manage "dc-run api ./manage.py"
alias hello "cd ~/dev/hello"


function fish_mode_prompt; end

function kitty-tab
  kitty @ new-window --new-tab --cwd $PWD --keep-focus --no-response --tab-title $argv[1] sh -c "$argv[2]; exec fish"
end

function hello-servers
  cd $HOME/dev/hello
  kitty @ set-tab-title api
  kitty-tab web "docker-compose up web"
  kitty-tab autonomous "docker-compose up autonomous-worker"
  docker-compose up api
end
