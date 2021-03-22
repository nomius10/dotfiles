function fish_prompt
    # A prompt inspired by nim prompt, peppered with kana/kanji related to japanese particles
    #
    # Shows:
    # - green kana if the last return command is OK, red otherwise
    # - your hostname, in cyan/blue if ssh/otherwise
    # - the current battery state, if any, and if your power cable is unplugged, and if you have "acpi"
    # - your user name, in red/yellow if root/otherwise
    # - date +%X
    # - the current virtual environment, if any
    # - the current git status, if any, with fish_git_prompt
    # - the current path (with prompt_pwd)
    # - number of background jobs, if any
    #
    # Example:
    # ┌SLATEデnomiusガ10:54:34時main=デ「~/.dotfiles」1用
    # └$

    set -l retc red
    test $status = 0; and set retc green

    set -q __fish_git_prompt_showupstream
    or set -g __fish_git_prompt_showupstream auto

    function _prompt_wrapper
        set particle $argv[1]
        set p_color  $argv[2]
        set value    $argv[3]
        set v_color  $argv[4]

        test -n $v_color; and set_color $v_color
        echo -n $value
        set_color normal
        set_color $p_color
        echo -n $particle
    end

    ### LINE 1
    set_color $retc
    echo -n '┌'
    # Hostname
    if [ -z "$SSH_CLIENT" ]
        set_color -o blue
    else
        set_color -o cyan
    end
    _prompt_wrapper 'デ' $retc (prompt_hostname)
    # Battery status
    type -q acpi
    and test (acpi -a 2> /dev/null | string match -r off)
    and _prompt_wrapper '丈' $retc (acpi -b | cut -d' ' -f 4-) normal
    # User
    if test "$USER" = root -o "$USER" = toor
        set_color -o red
        set bang '#'
    else
        set_color -o yellow
        set bang '$'
    end
    _prompt_wrapper 'ガ' $retc $USER
    # Time
    _prompt_wrapper '時' $retc (date +"%X") normal
    # PWD
    set_color normal
    _prompt_wrapper 'ニ' $retc '「'(prompt_pwd)'」' normal
    echo -n
    # Virtual Environment
    set -q VIRTUAL_ENV_DISABLE_PROMPT
    or set -g VIRTUAL_ENV_DISABLE_PROMPT true
    set -q VIRTUAL_ENV
    and _prompt_wrapper '幻' $retc (basename "$VIRTUAL_ENV") normal
    # git
    set prompt_git (fish_git_prompt | string trim -c ' ()')
    test -n "$prompt_git"
    and _prompt_wrapper '枝' $retc $prompt_git normal
    # Background jobs
    test 0 -ne (count (jobs))
    and _prompt_wrapper '用' $retc (count (jobs)) normal

    ### LINE 2
    echo ''
    set_color $retc
    echo -n '└'
    set_color -o red
    echo -n $bang' '
    set_color normal
end
