if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting
end

# opencode
fish_add_path /home/bogus/.opencode/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
