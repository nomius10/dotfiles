function fish_prompt
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
    # Virtual Environment
    set -q VIRTUAL_ENV_DISABLE_PROMPT
    or set -g VIRTUAL_ENV_DISABLE_PROMPT true
    set -q VIRTUAL_ENV
    and _prompt_wrapper '幻' $retc (basename "$VIRTUAL_ENV") normal
    # git
    set prompt_git (fish_git_prompt | string trim -c ' ()')
    test -n "$prompt_git"
    and _prompt_wrapper 'デ' $retc $prompt_git normal
    # PWD
    set_color normal
    echo -n '「'(prompt_pwd)'」'
    # Background jobs
    test 0 -ne (count (jobs))
    and _prompt_wrapper '用' $retc (count (jobs))

    ### LINE 2
    echo ''
    set_color $retc
    echo -n '└'
    set_color -o red
    echo -n $bang' '
    set_color normal
end
