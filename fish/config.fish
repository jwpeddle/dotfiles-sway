# ******************** fish ********************
set -g fish_greeting

# ******************** defaults ********************
set -x PAGER "nvimpager"
set -x EDITOR "nvim"
set -x TERM "xterm-kitty"

# paths
set -x PATH "$HOME/.local/bin" $PATH
set -x XDG_CONFIG_HOME "$HOME/.config"

# make capslock ctrl
set -x XKB_DEFAULT_OPTIONS "ctrl:nocaps"

# run ssh-agent automatically
if type -q fish_ssh_agent
  fish_ssh_agent
else
  echo "fish plugins not installed, install fisher and run `fisher update`"
end

# ******************** Key bindings ********************
# fzf
function fish_user_key_bindings
  fish_vi_key_bindings
  fzf_key_bindings
  bind -k nul "br"
  bind -M insert -k nul "br"
end


# ******************** other configs ********************

# bat
set -x BAT_THEME "Dracula"

# direnv
set -x DIRENV_LOG_FORMAT ""
if type -q direnv
  direnv hook fish | source
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
set -x PATH "$GOPATH/bin" $PATH
set -x GIT_TERMINAL_PROMPT 1

# node
set -x NPM_CONFIG_PREFIX "$HOME/.node_modules"
set -x PATH "$NPM_CONFIG_PREFIX/bin" $PATH

# python / pyenv
set -x PYTHONDONTWRITEBYTECODE "1"

if type -q pyenv
  set -x PYENV_ROOT "$HOME/.pyenv"
  set -x PATH "$PYENV_ROOT/bin" $PATH
  status is-login; and pyenv init --path | source
  pyenv init - | source
  status --is-interactive; and pyenv virtualenv-init - | source
end

# ripgrep
set -x RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"

# starship
if type -q starship
  starship init fish | source
else
  echo "starship not found"
end

# ******************** functions ********************
alias sudo "sudo -E"
alias update "sudo aura -Syyux && sudo aura -Ayyux"
alias icat "kitty +kitten icat"
alias dc "docker-compose"
alias dc-run "dc run --rm"
alias reload "source $HOME/.config/fish/config.fish"

function fish_mode_prompt; end

function kitty-tab
  kitty @ new-window --new-tab --cwd $PWD --keep-focus --no-response --tab-title $argv[1] sh -c "$argv[2]; exec fish"
end

set hellodir "$HOME/dev/hello"
function hello
  set sub_command $argv[1]
  set --erase argv[1]

  switch $sub_command
    case ""
      cd $hellodir

    case "manage.py"
      set manage_command $argv[1]
      set --erase argv[1]
      switch $manage_command
        case "shell"
          $hellodir/api/manage.py shell_plus --ptipython $argv
        case "test"
          python -Wa -b $hellodir/api/manage.py test --nomigrations --no-input $argv
        case "runserver"
          $hellodir/api/manage.py runserver 0.0.0.0:3001
        case "*"
          $hellodir/api/manage.py $manage_command $argv
      end
  end
end
complete -f -c hello -a "cd manage.py"


function hello-servers
  cd $HOME/dev/hello
  kitty @ set-tab-title api
  kitty-tab web "docker-compose up web"
  kitty-tab autonomous "docker-compose up autonomous-worker"
  docker-compose up api
end