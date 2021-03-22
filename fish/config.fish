abbr -a c cargo
abbr -a e nvim
abbr -a vimdiff 'nvim -d'
abbr -a vim "echo use 'e' you dummkopft;#"
abbr -a g git
abbr -a gds 'git diff --staged'
abbr -a py python3

# Check/add userpaths
set my_paths \
    $HOME/.cargo/bin \
    $HOME/bin \
    $HOME/.local/bin

for path in $my_paths
    contains $path $fish_user_paths
    or begin
        echo "Notice: setting userpath $path as it was unset..."
        set -Ua fish_user_paths $path
    end
end

set -e my_paths
