# Add Starship to path
starship init fish | source

# Add Zoxide to path
zoxide init fish | source

# Add Mise to path
~/.local/bin/mise activate fish | source

# Add Zellij to path
if status is-interactive
    eval (zellij setup --generate-auto-start fish | string collect)
end

# File system alias
alias ls='eza -lh --group-directories-first --icons'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias tree='eza --tree'
alias f="fd"
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias cd='z'

# Directories alias
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools alias
alias n='nvim'
alias g='git'
alias b='bat'
alias lzg='lazygit'
alias lzd='lazydocker'

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
