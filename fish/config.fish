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

# run ssh-agent automatically
if type -q fish_ssh_agent
  fish_ssh_agent
else
  echo "fish plugins not installed, install fisher and run `fisher update`"
end

# make colors work right in nvim?
set -x fish_term24bit 1


# ******************** Functions ********************


# ******************** Key bindings ********************
# fzf
function fish_user_key_bindings
  fish_default_key_bindings
  #fish_vi_key_bindings
  fzf_key_bindings
  bind -k nul "br"
  bind -M insert -k nul "br"
end


# ******************** other configs ********************

# bat
set -x BAT_THEME "Dracula"
set -x COLORTERM "truecolor"

# direnv
set -x DIRENV_LOG_FORMAT ""
if type -q direnv
  direnv hook fish | source
end

# fzf
set -x FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS
  --layout=reverse
  --no-info
  --border
  --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
  --preview 'bat --color=always --style=header,grid --line-range :300 {}'
"
set -x FZF_DEFAULT_COMMAND "fd --type file"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

# go
set -x GOPATH "$HOME/go"
fish_add_path "$GOPATH/bin"
set -x GIT_TERMINAL_PROMPT 1

# neovim
set -x DOTFILES_HOME "$HOME/dotfiles"
set -x NVIM_HOME "$DOTFILES_HOME/nvim"

# node
set -x NPM_CONFIG_PREFIX "$HOME/.node_modules"
fish_add_path "$NPM_CONFIG_PREFIX/bin"

# python / pyenv
set -x PYTHONDONTWRITEBYTECODE "1"
set -x PYTHONSTARTUP "$HOME/.pythonstartup"

if type -q pyenv
  set -x PYENV_ROOT "$HOME/.pyenv"
  fish_add_path "$PYENV_ROOT/bin"
  status is-login; and pyenv init --path | source
  pyenv init - | source
  status --is-interactive; and pyenv virtualenv-init - | source
end

# ripgrep
set -x RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"

# ruby
set -x GEM_HOME (ruby -e 'print Gem.user_dir')
fish_add_path "$GEM_HOME/bin"

# starship
if type -q starship
  starship init fish | source
else
  echo "starship not found"
end

# ******************** functions ********************
function fish_mode_prompt; end

function postexec --on-event fish_postexec
  echo
end

alias sudo "sudo -E"
alias update "sudo aura -Syyux && sudo aura -Ayyux"
alias icat "kitty +kitten icat"
alias dc "docker-compose"
alias dc-run "dc run --rm"
alias reload "source $HOME/.config/fish/config.fish"
alias fd "fd\
  --hidden\
  --no-ignore\
  --exclude '.cache'\
  --exclude '.git'\
  --exclude '.pyenv'\
  --exclude '__pycache__'\
  --exclude 'dotbot'\
  --exclude 'node_modules'\
"

function kitty-tab
  kitty @ new-window --new-tab --cwd $PWD --keep-focus --no-response --tab-title $argv[1] sh -c "$argv[2]; exec fish"
end

function pacinstall -a package category
  set -q category[1]
  or set category "triage"
  if rg "^$package\$" ~/dotfiles/pacmanfile/ &> /dev/null
    echo "Package already installed"
  else
    echo "Installing $package"
    echo $package >> ~/dotfiles/pacmanfile/pacmanfile-$category.txt
    pacmanfile sync
  end
end

set hellodir "$HOME/dev/hello"
function hello
  set sub_command $argv[1]
  set --erase argv[1]

  switch $sub_command
    case ""
      cd $hellodir

    case "up"
      docker compose up api

    case "test"
      pytest src $argv

    case "manage.py"
      set manage_command $argv[1]
      set --erase argv[1]
      switch $manage_command
        case "shell"
          $hellodir/src/manage.py shell_plus --ipython $argv
        case "runserver"
          $hellodir/src/manage.py runserver 0.0.0.0:3001
        case "*"
          $hellodir/src/manage.py $manage_command $argv
      end
  end
end
abbr --add h hello
complete -f -c hello -a "up test manage.py"

set nebuladir "$HOME/dev/nebula-content"
function nebula
  set sub_command $argv[1]
  set --erase argv[1]

  switch $sub_command
    case ""
      cd $nebuladir

    case "up"
      docker compose up web

    case "manage.py"
      set manage_command $argv[1]
      set --erase argv[1]
      switch $manage_command
        case "shell"
          $nebuladir/api/manage.py shell_plus --ipython $argv
        case "runserver"
          $nebuladir/api/manage.py runserver 0.0.0.0:10999
        case "*"
          $nebuladir/api/manage.py $manage_command $argv
      end
  end
end
abbr --add n nebula
complete -f -c nebula -a "up manage.py"

thefuck --alias | source
